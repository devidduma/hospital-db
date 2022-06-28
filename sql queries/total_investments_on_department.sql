/* How much are investments in assets for each department worth? */

select department.department_id, sum(asset_room.quantity * asset_instances.purchase_price) as total_investment_in_assets
from department join room
    on department.department_id = room.department_id
join asset_room
    on asset_room.branch_id = room.branch_id and asset_room.room_id = room.room_id
join asset_instances
    on asset_room.asset_id = asset_instances.asset_id
group by department.department_id
