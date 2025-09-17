SELECT
    parent.id,
    parent.title,
    child.id,
    child.title,
    grandchild.id,
    grandchild.title
FROM
    tasks AS parent
JOIN
    tasks AS child ON child.parent_id = parent.id
JOIN
    tasks AS grandchild ON grandchild.parent_id = child.id
WHERE
    parent.id = 1;