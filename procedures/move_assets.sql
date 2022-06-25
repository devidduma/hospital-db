DELIMITER $$
drop procedure if exists move_assets$$

create procedure move_assets(
asset_id int unsigned,
room_id int unsigned,
branch_id int unsigned,
destination_room_id int unsigned,
destination_branch_id int unsigned,
desired_quantity int unsigned
)

/* Move assets from one room to another. */
BEGIN
    declare row_exists bool;
    declare current_quantity int unsigned;
    declare destination_row_exists bool;
    declare errormsg varchar(200);

    set current_quantity = (
        select ar.quantity
        from asset_room ar
        where ar.asset_id = asset_id
            and ar.room_id = room_id
            and ar.branch_id = branch_id
        );
    set row_exists = (current_quantity is not null);

    -- If there is no source location for asset_id, signal error message.
    if row_exists = 0 then
        SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
        SET MESSAGE_TEXT = 'Row does not exist. Please check your asset_id, room_id and branch_id.';
    end if ;

    -- If available quantity is less than desired quantity.
    if current_quantity < desired_quantity then
        SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
        SET MESSAGE_TEXT = "Available quantity is less than desired quantity! Choose another value.";
    end if ;

    -- Remove assets from current location.
    update asset_room ar
    set ar.quantity = ar.quantity - desired_quantity
    where ar.asset_id = asset_id
        and ar.room_id = room_id
        and ar.branch_id = branch_id;

    -- Find out if destination location already has some asset_id.
    set destination_row_exists = (
        select count(ar.quantity)
        from asset_room ar
        where ar.asset_id = asset_id
            and ar.room_id = destination_room_id
            and ar.branch_id = destination_branch_id
        );

    -- Update / Insert into destination location.
    if destination_row_exists then
        update asset_room ar
        set ar.quantity = ar.quantity + desired_quantity
        where ar.asset_id = asset_id
            and ar.room_id = destination_room_id
            and ar.branch_id = destination_branch_id;
    else
        insert into asset_room
        values (asset_id, room_id, desired_quantity, branch_id);
    end if ;

    select concat("Moved ", desired_quantity, " assets successfully!");
END $$

-- Successfully move 2 items.
call move_assets(1, 102, 1, 101, 1, 2);
-- No asset_id on source location.
call move_assets(1, 103, 1, 101, 1, 2);
-- Desired quantity is more than available quantity.
call move_assets(1, 102, 1, 101, 1, 100);
