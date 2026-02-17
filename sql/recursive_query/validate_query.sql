-- SOURCE /workspace/sql/recursive_query/validate_query.sql;

DROP TABLE IF EXISTS issue;

CREATE TABLE issue (
  id INT NOT NULL,
  parent_issue_id INT,
  status_id INT NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO issue (id, parent_issue_id, status_id) VALUES
(1, NULL, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 1),
(5, 2, 4),
(6, 3, 2),
(7, 3, 5);

-- Set issueId to 1 to find all descendants of issue 1.
-- Set uncompletedStatusIds to 1, 2 which mean 'open' or 'in progress'.
WITH RECURSIVE all_descendants(id, parent_issue_id, status_id, root_child_id) AS (
  SELECT id, parent_issue_id, status_id, id as root_child_id
  FROM issue
  WHERE parent_issue_id = 1
  UNION ALL
  SELECT i.id, i.parent_issue_id, i.status_id, d.root_child_id
  FROM issue i JOIN all_descendants d ON i.parent_issue_id = d.id
)
SELECT DISTINCT root_child_id
FROM all_descendants
WHERE status_id IN (1, 2)
ORDER BY root_child_id;
