SELECT 
    DATE(t1.request_at) AS "Day",
    ROUND(COUNT(CASE WHEN t1.status LIKE 'cancel%' THEN 1 END) * 1.0 / COUNT(t1.id), 2) AS "Cancellation Rate"
FROM 
    (SELECT 
        tr.id, 
        tr.client_id, 
        us.role AS client_role, 
        us.banned AS client_banned,
        tr.status,
        tr.request_at
    FROM trips tr
    JOIN users us ON tr.client_id = us.users_id
    WHERE us.banned = 'no') AS t1
JOIN 
    (SELECT 
        tr.id, 
        tr.driver_id, 
        us.role AS driver_role, 
        us.banned AS driver_banned
    FROM trips tr
    JOIN users us ON tr.driver_id = us.users_id
    WHERE us.banned = 'no') AS t2
ON t1.id = t2.id
GROUP BY DATE(t1.request_at)
ORDER BY DATE(t1.request_at);
