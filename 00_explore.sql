-- Start here. One row in this output represents one database table.
SELECT name AS TableName
FROM sqlite_master
WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
ORDER BY name;
