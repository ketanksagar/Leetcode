"
Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.
Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), 
and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum 
number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.
  
  "


WITH t1 AS (
    SELECT 
        submission_date AS dat,
        hackers.hacker_id AS id,
        name,
        COUNT(DISTINCT submission_id) AS submn_count,
        COUNT(DISTINCT hackers.hacker_id) AS cnt
    FROM 
        hackers
    INNER JOIN 
        submissions ON hackers.hacker_id = submissions.hacker_id
    GROUP BY 
        submission_date, hackers.hacker_id, name
),
t2 AS (
    SELECT 
        dat,
        id,
        name,
        cnt,
        submn_count,
        SUM(cnt) OVER (PARTITION BY id ORDER BY dat) AS uniq,
        DENSE_RANK() OVER (ORDER BY dat ASC) AS row_num
    FROM 
        t1
),
t3 AS (
    SELECT 
        dat,
        SUM(CASE WHEN row_num = uniq THEN cnt ELSE 0 END) OVER (PARTITION BY dat) AS uniq_cnt,
        id,
        name,
        RANK() OVER (PARTITION BY dat ORDER BY submn_count DESC, id ASC) AS max_submn
    FROM 
        t2
)
SELECT 
    dat,
    uniq_cnt,
    id,
    name
FROM 
    t3
WHERE 
    max_submn = 1;
