from typing import List, Tuple, Union

from flask import current_app
import pandas as pd
import numpy as np
from typing import Dict
from pandas.tseries.frequencies import to_offset
from pyomo.core import (
    ConcreteModel,
    Var,
    RangeSet,
    Param,
    Reals,
    NonNegativeReals,
    NonPositiveReals,
    Constraint,
    Objective,
    minimize,
)
from pyomo.environ import UnknownSolver  # noqa F401
from pyomo.environ import value
from pyomo.opt import SolverFactory, SolverResults

from flexmeasures.data.models.planning.utils import initialize_series

infinity = float("inf")


def device_scheduler(  # noqa C901
    device_constraints: List[pd.DataFrame],
    ems_constraints: pd.DataFrame,
    commitment_quantities: List[pd.Series],
    consumption_price_sensor_per_device: Dict[int, int],
    production_price_sensor_per_device: Dict[int, int],
    # commitment_downwards_deviation_price: Union[List[pd.Series], List[float]],
    # commitment_upwards_deviation_price: Union[List[pd.Series], List[float]],
    commitment_downwards_deviation_price_array: List[Union[List[pd.Series], List[float]]],
    commitment_upwards_deviation_price_array: List[Union[List[pd.Series], List[float]]]
) -> Tuple[List[pd.Series], float, SolverResults]:
    """This generic device scheduler is able to handle an EMS with multiple devices,
    with various types of constraints on the EMS level and on the device level,
    and with multiple market commitments on the EMS level.
    A typical example is a house with many devices.
    The commitments are assumed to be with regard to the flow of energy to the device (positive for consumption,
    negative for production). The solver minimises the costs of deviating from the commitments.

    Device constraints are on a device level. Handled constraints (listed by column name):
        max: maximum stock assuming an initial stock of zero (e.g. in MWh or boxes)
        min: minimum stock assuming an initial stock of zero
        equal: exact amount of stock (we do this by clamping min and max)
        derivative max: maximum flow (e.g. in MW or boxes/h)
        derivative min: minimum flow
        derivative equals: exact amount of flow (we do this by clamping derivative min and derivative max)
        derivative down efficiency: conversion efficiency of flow out of a device (flow out : stock decrease)
        derivative up efficiency: conversion efficiency of flow into a device (stock increase : flow in)
    EMS constraints are on an EMS level. Handled constraints (listed by column name):
        derivative max: maximum flow
        derivative min: minimum flow
    Commitments are on an EMS level. Parameter explanations:
        commitment_quantities: amounts of flow specified in commitments (both previously ordered and newly requested)
            - e.g. in MW or boxes/h
        commitment_downwards_deviation_price: penalty for downwards deviations of the flow
            - e.g. in EUR/MW or EUR/(boxes/h)
            - either a single value (same value for each flow value) or a Series (different value for each flow value)
        commitment_upwards_deviation_price: penalty for upwards deviations of the flow

    All Series and DataFrames should have the same resolution.

    For now, we pass in the various constraints and prices as separate variables, from which we make a MultiIndex
    DataFrame. Later we could pass in a MultiIndex DataFrame directly.
    """
    # Print device constraints
    # for i, df in enumerate(device_constraints):
    #     print(f"Device constraints {i}:")
    #     print(df.to_string())
    #     print()

    # # Print EMS constraints
    # print("EMS constraints:")
    # print(ems_constraints.to_string())
    # print()

    # # Print commitment quantities
    # for i, s in enumerate(commitment_quantities):
    #     print(f"Commitment quantities {i}:")
    #     print(s.to_string())
    #     print()

    # # Print downwards deviation prices
    # for i, series_or_float in enumerate(commitment_downwards_deviation_price):
    #     print(f"Commitment downwards deviation price {i}:")
    #     if isinstance(series_or_float, pd.Series):
    #         print(series_or_float.to_string())
    #     else:
    #         print(series_or_float)
    #     print()

    # # Print upwards deviation prices
    # for i, series_or_float in enumerate(commitment_upwards_deviation_price):
    #     print(f"Commitment upwards deviation price {i}:")
    #     if isinstance(series_or_float, pd.Series):
    #         print(series_or_float.to_string())
    #     else:
    #         print(series_or_float)
    #     print()
    
    # # Print downwards deviation prices
    # print("commitment_downwards_deviation_price")
    # print(commitment_upwards_deviation_price_array)
    # for commitment_downwards_deviation_price in commitment_downwards_deviation_price_array:
    #     for i, series_or_float in enumerate(commitment_downwards_deviation_price):
    #         print(f"Commitment downwards deviation price {i}:")
    #         if isinstance(series_or_float, pd.Series):
    #             print(series_or_float.to_string())
    #         else:
    #             print(series_or_float)
    #         print()
    #     print()    

    # # Print upwards deviation prices
    print("commitment_upwards_deviation_price from linear_optimization")
    # for commitment_upwards_deviation_price in commitment_upwards_deviation_price_array:
    #     for i, series_or_float in enumerate(commitment_upwards_deviation_price):
    #         print(f"Commitment upwards deviation price {i}:")
    #         if isinstance(series_or_float, pd.Series):
    #             print(series_or_float.to_string())
    #         else:
    #             print(series_or_float)
    #         print()
    #     print()    

    # If the EMS has no devices, don't bother
    if len(device_constraints) == 0:
        return [], 0, SolverResults()

    # Check if commitments have the same time window and resolution as the constraints
    start = device_constraints[0].index.to_pydatetime()[0]
    resolution = pd.to_timedelta(device_constraints[0].index.freq)
    end = device_constraints[0].index.to_pydatetime()[-1] + resolution
    if len(commitment_quantities) != 0:
        start_c = commitment_quantities[0].index.to_pydatetime()[0]
        resolution_c = pd.to_timedelta(commitment_quantities[0].index.freq)
        end_c = commitment_quantities[0].index.to_pydatetime()[-1] + resolution
        if not (start_c == start and end_c == end):
            raise Exception(
                "Not implemented for different time windows.\n(%s,%s)\n(%s,%s)"
                % (start, end, start_c, end_c)
            )
        if resolution_c != resolution:
            raise Exception(
                "Not implemented for different resolutions.\n%s\n%s"
                % (resolution, resolution_c)
            )

    # if len(commitment_downwards_deviation_price) != 0:
    #     if all(
    #         isinstance(price, float) for price in commitment_downwards_deviation_price
    #     ):
    #         commitment_downwards_deviation_price = [
    #             initialize_series(price, start, end, resolution)
    #             for price in commitment_downwards_deviation_price
    #         ]
    # if len(commitment_upwards_deviation_price) != 0:
    #     if all(
    #         isinstance(price, float) for price in commitment_upwards_deviation_price
    #     ):
    #         commitment_upwards_deviation_price = [
    #             initialize_series(price, start, end, resolution)
    #             for price in commitment_upwards_deviation_price
    #         ]

    # Turn prices per commitment into prices per commitment flow
    for i in range(0, len(commitment_downwards_deviation_price_array)):
        if len(commitment_downwards_deviation_price_array[i]) != 0:
            if all(
                isinstance(price, float) for price in commitment_downwards_deviation_price_array[i]
            ):
                commitment_downwards_deviation_price_array[i] = [
                    initialize_series(price, start, end, resolution)
                    for price in commitment_downwards_deviation_price_array[i]
                ]

    for i in range(0, len(commitment_upwards_deviation_price_array)):            
        if len(commitment_upwards_deviation_price_array[i]) != 0:
            if all(
                isinstance(price, float) for price in commitment_upwards_deviation_price_array[i]
            ):
                commitment_upwards_deviation_price_array[i] = [
                    initialize_series(price, start, end, resolution)
                    for price in commitment_upwards_deviation_price_array[i]
                ]

    model = ConcreteModel()

    # Add indices for devices (d), datetimes (j) and commitments (c)
    model.d = RangeSet(0, len(device_constraints) - 1, doc="Set of devices")
    model.j = RangeSet(
        0, len(device_constraints[0].index.to_pydatetime()) - 1, doc="Set of datetimes"
    )
    model.c = RangeSet(0, len(commitment_quantities) - 1, doc="Set of commitments")

    # Add parameters
    def price_down_select(m, c, j):
        # return commitment_downwards_deviation_price[c].iloc[j]
        return [commitment_downwards_deviation_price[c].iloc[j] for commitment_downwards_deviation_price in commitment_downwards_deviation_price_array]

    def price_up_select(m, c, j):
        # return commitment_upwards_deviation_price[c].iloc[j]
        return [commitment_upwards_deviation_price[c].iloc[j] for commitment_upwards_deviation_price in commitment_upwards_deviation_price_array]

    model.up_price = Param(model.c, model.j, initialize=price_up_select)
    model.down_price = Param(model.c, model.j, initialize=price_down_select)
    
    def commitment_quantity_select(m, c, j):
        return commitment_quantities[c].iloc[j]

    def device_max_select(m, d, j):
        max_v = device_constraints[d]["max"].iloc[j]
        equal_v = device_constraints[d]["equals"].iloc[j]
        if np.isnan(max_v) and np.isnan(equal_v):
            return infinity
        else:
            return np.nanmin([max_v, equal_v])

    def device_min_select(m, d, j):
        min_v = device_constraints[d]["min"].iloc[j]
        equal_v = device_constraints[d]["equals"].iloc[j]
        if np.isnan(min_v) and np.isnan(equal_v):
            return -infinity
        else:
            return np.nanmax([min_v, equal_v])

    def device_derivative_max_select(m, d, j):
        max_v = device_constraints[d]["derivative max"].iloc[j]
        equal_v = device_constraints[d]["derivative equals"].iloc[j]
        if np.isnan(max_v) and np.isnan(equal_v):
            return infinity
        for (c,ji) in model.up_price:
            # print(c)
            for commitment_upwards_deviation_price in commitment_upwards_deviation_price_array:
                if (model.up_price[(c,j)] == commitment_upwards_deviation_price[(consumption_price_sensor_per_device[d],c)].iloc[j]):
                    # print(max_v)
                    # print(equal_v)
                    return np.nanmin([max_v, equal_v])

        return infinity

    def device_derivative_min_select(m, d, j):
        min_v = device_constraints[d]["derivative min"].iloc[j]
        equal_v = device_constraints[d]["derivative equals"].iloc[j]
        if np.isnan(min_v) and np.isnan(equal_v):
            return -infinity
        for (c,ji) in model.down_price:
            for commitment_downwards_deviation_price in commitment_downwards_deviation_price_array:
                if (model.down_price[(c,j)] == commitment_downwards_deviation_price[production_price_sensor_per_device[d],c].iloc[j]):
            # print(c)
            # if (model.down_price[c] == consumption_price_sensor_per_device[equal_v]):
                    return np.nanmin([min_v, equal_v])
              
        return -infinity

    def ems_derivative_max_select(m, j):
        v = ems_constraints["derivative max"].iloc[j]
        if np.isnan(v):
            return infinity
        else:
            return v

    def ems_derivative_min_select(m, j):
        v = ems_constraints["derivative min"].iloc[j]
        if np.isnan(v):
            return -infinity
        else:
            return v

    def device_derivative_down_efficiency(m, d, j):
        """Assume perfect efficiency if no efficiency information is available."""
        try:
            eff = device_constraints[d]["derivative down efficiency"].iloc[j]
        except KeyError:
            return 1
        if np.isnan(eff):
            return 1
        return eff

    def device_derivative_up_efficiency(m, d, j):
        """Assume perfect efficiency if no efficiency information is available."""
        try:
            eff = device_constraints[d]["derivative up efficiency"].iloc[j]
        except KeyError:
            return 1
        if np.isnan(eff):
            return 1
        return eff

    model.commitment_quantity = Param(
        model.c, model.j, initialize=commitment_quantity_select
    )
    model.device_max = Param(model.d, model.j, initialize=device_max_select)
    model.device_min = Param(model.d, model.j, initialize=device_min_select)
    model.device_derivative_max = Param(
        model.d, model.j, initialize=device_derivative_max_select
    )
    model.device_derivative_min = Param(
        model.d, model.j, initialize=device_derivative_min_select
    )
    model.ems_derivative_max = Param(model.j, initialize=ems_derivative_max_select)
    model.ems_derivative_min = Param(model.j, initialize=ems_derivative_min_select)
    model.device_derivative_down_efficiency = Param(
        model.d, model.j, initialize=device_derivative_down_efficiency
    )
    model.device_derivative_up_efficiency = Param(
        model.d, model.j, initialize=device_derivative_up_efficiency
    )

    # Add variables
    model.ems_power = Var(model.d, model.j, domain=Reals, initialize=0)
    model.device_power_down = Var(
        model.d, model.j, domain=NonPositiveReals, initialize=0
    )
    model.device_power_up = Var(model.d, model.j, domain=NonNegativeReals, initialize=0)
    model.commitment_downwards_deviation = Var(
        model.c, model.j, domain=NonPositiveReals, initialize=0
    )
    model.commitment_upwards_deviation = Var(
        model.c, model.j, domain=NonNegativeReals, initialize=0
    )

    # Print the indices of the RangeSets
    # print("Device set:", model.d.value)
    # print("Datetime set:", model.j.value)
    # print("Commitment set:", model.c.value)

    # # Print the values of the parameters
    # print("Upward price:", model.up_price.extract_values())
    # print("Downward price:", model.down_price.extract_values())
    # print("Commitment quantity:", model.commitment_quantity.extract_values())

    # print("Device maximum power output:", model.device_max.extract_values())
    # print("Device minimum power output:", model.device_min.extract_values())
    # print("Device maximum ramping rate:", model.device_derivative_max.extract_values())
    # print("Device minimum ramping rate:", model.device_derivative_min.extract_values())
    # print("EMS maximum ramping rate:", model.ems_derivative_max.extract_values())
    # print("EMS minimum ramping rate:", model.ems_derivative_min.extract_values())
    # print("Device ramping down efficiency:", model.device_derivative_down_efficiency.extract_values())
    # print("Device ramping up efficiency:", model.device_derivative_up_efficiency.extract_values())

    # Add constraints as a tuple of (lower bound, value, upper bound)
    def device_bounds(m, d, j):
        """Apply efficiencies to conversion from flow to stock change and vice versa."""
        return (
            m.device_min[d, j],
            sum(
                m.device_power_down[d, k] / m.device_derivative_down_efficiency[d, k]
                + m.device_power_up[d, k] * m.device_derivative_up_efficiency[d, k]
                for k in range(0, j + 1)
            ),
            m.device_max[d, j],
        )

    def device_derivative_bounds(m, d, j):
        return (
            m.device_derivative_min[d, j],
            m.device_power_down[d, j] + m.device_power_up[d, j],
            m.device_derivative_max[d, j],
        )

    def device_down_derivative_bounds(m, d, j):
        """Strictly non-positive."""
        return (
            min(m.device_derivative_min[d, j], 0),
            m.device_power_down[d, j],
            0,
        )

    def device_up_derivative_bounds(m, d, j):
        """Strictly non-negative."""
        return (
            0,
            m.device_power_up[d, j],
            max(0, m.device_derivative_max[d, j]),
        )

    def ems_derivative_bounds(m, j):
        return m.ems_derivative_min[j], sum(m.ems_power[:, j]), m.ems_derivative_max[j]

    def ems_flow_commitment_equalities(m, j):
        """Couple EMS flows (sum over devices) to commitments."""
        return (
            0,
            sum(m.commitment_quantity[:, j])
            + sum(m.commitment_downwards_deviation[:, j])
            + sum(m.commitment_upwards_deviation[:, j])
            - sum(m.ems_power[:, j]),
            0,
        )

    def device_derivative_equalities(m, d, j):
        """Couple device flows to EMS flows per device."""
        return (
            0,
            m.device_power_up[d, j] + m.device_power_down[d, j] - m.ems_power[d, j],
            0,
        )

    model.device_energy_bounds = Constraint(model.d, model.j, rule=device_bounds)
    model.device_power_bounds = Constraint(
        model.d, model.j, rule=device_derivative_bounds
    )
    model.device_power_down_bounds = Constraint(
        model.d, model.j, rule=device_down_derivative_bounds
    )
    model.device_power_up_bounds = Constraint(
        model.d, model.j, rule=device_up_derivative_bounds
    )
    model.ems_power_bounds = Constraint(model.j, rule=ems_derivative_bounds)
    model.ems_power_commitment_equalities = Constraint(
        model.j, rule=ems_flow_commitment_equalities
    )
    model.device_power_equalities = Constraint(
        model.d, model.j, rule=device_derivative_equalities
    )

    # Print the values of the constraints
    # print("Device energy bounds:")
    # for i, j in model.device_energy_bounds:
    #     print(f"Device {i} at datetime {j}:", model.device_energy_bounds[i, j]())

    # print("Device power bounds:")
    # for i, j in model.device_power_bounds:
    #     print(f"Device {i} at datetime {j}:", model.device_power_bounds[i, j]())

    # print("Device power down bounds:")
    # for i, j in model.device_power_down_bounds:
    #     print(f"Device {i} at datetime {j}:", model.device_power_down_bounds[i, j]())

    # print("Device power up bounds:")
    # for i, j in model.device_power_up_bounds:
    #     print(f"Device {i} at datetime {j}:", model.device_power_up_bounds[i, j]())

    # print("EMS power bounds:")
    # for j in model.ems_power_bounds:
    #     print(f"EMS at datetime {j}:", model.ems_power_bounds[j]())

    # print("EMS power commitment equalities:")
    # for j in model.ems_power_commitment_equalities:
    #     print(f"EMS at datetime {j}:", model.ems_power_commitment_equalities[j]())

    # print("Device power equalities:")
    # for i, j in model.device_power_equalities:
    #     print(f"Device {i} at datetime {j}:", model.device_power_equalities[i, j]())

    # Add objective
    
    def cost_function(m):
        costs = 0
        for c in m.c:
            for j in m.j:
                for i in range(0,len(m.down_price[c,j])):
                    costs += m.commitment_downwards_deviation[c, j] * m.down_price[c, j][i]
                    costs += m.commitment_upwards_deviation[c, j] * m.up_price[c, j][i]
        return costs

    model.costs = Objective(rule=cost_function, sense=minimize)

    # Solve
    results = SolverFactory(current_app.config.get("FLEXMEASURES_LP_SOLVER")).solve(
        model
    )

    planned_costs = value(model.costs)
    planned_power_per_device = []
    for d in model.d:
        planned_device_power = [model.ems_power[d, j].value for j in model.j]
        planned_power_per_device.append(
            initialize_series(
                data=planned_device_power,
                start=start,
                end=end,
                resolution=to_offset(resolution),
            )
        )

    # model.pprint()
    # model.display()
    # print(results.solver.termination_condition)
    print(planned_costs)
    print(results)
    # print(planned_power_per_device)
    return planned_power_per_device, planned_costs, results
