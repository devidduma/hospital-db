/* List staff's salary in descending order. */

select Dense_Rank()
    over (order by E.salary desc) as highest,
    E.salary, E.staff_id, CONCAT_WS(' ',E.first_name , E.second_name) AS STAFF_NAME
from staff E;
