/* Show oldest assets with most expected lifetime. */

select asset_id,type_name, year, expected_lifetime
from asset_type, asset_instances
    where asset_id = asset_type.asset_type_id
        and expected_lifetime = (
            select max(expected_lifetime)
            from asset_instances
            where year in (
                select min(year)
                from asset_instances
            )
        );
