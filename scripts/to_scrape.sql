/*
We want to recheck old cases for updates in a somewhat smart way.
If we knew that one case was being updated more frequently than another
we would want to check the more frequent case more often. The code
below attempts to do that.

inspired by Cho and Molina, Estimating Frequency of Change
https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=60c8e42055dfb80072a547c73fbc18dfbacc20aa

Let t_changed_i be the last time we recorded a change in a case i and
let t_checked_i be the last time we checked if the case changed, then
a reasonable estimator of the rate of change is r_i = 1/(t_checked_i -
t_changed_i).

However, if the last time we checked for a change, the case was
changed then t_checked_i - t_changed_i = 0 and r_i will be undefined.

We can smooth that out by using a prior belief for the rate of
change. We will use the average rate of change:

B = (sum_i 1 / (t_checked_i - t_changed_i)) / N

for all cases where t_checked_i > t_changed_i

We will control the effect of the prior with the parameter A, so
that the case specific estimate of the rate of change is

r_i = (A + 1) / (A/B + (t_checked_i - t_changed_i))

With this case specific estimate, we can use the Poisson distribution
to calculate the probability that a case has changed since the last
time we checked it.

p_i = 1 - exp(-r_i * (t_now - t_checked_i))

for the purposes of ordering, we can simply use the interior term

r_i * (t_now - t_checked_i)
*/


CREATE TEMPORARY TABLE raw_filing (name text,
                                   case_number text,
	                           city text,
	                           state text,
	                           date_filed text,
	                           region_assigned text,
	                           status text,
	                           date_closed text,
	                           reason_closed text,
	                           number_of_eligible_voters int,
	                           number_of_voters_on_petition_or_charge int,
	                           certified_representative text,
	                           unit_sought text);

.mode csv
.import /dev/stdin raw_filing

WITH overall_rate AS (
    SELECT
        sum(1 / (julianday (last_checked_at) - julianday (updated_at))) / count(*) FILTER (WHERE julianday (last_checked_at) > julianday (updated_at)) AS rate,
        3 AS prior_weight
    FROM
        filing
    WHERE
        status != 'Closed'
)
SELECT
    raw_filing.case_number
FROM
    raw_filing
    LEFT JOIN filing USING (case_number)
WHERE
    filing.case_number IS NULL
UNION ALL
SELECT
    case_number
FROM (
    SELECT
        case_number
    FROM
        filing
        INNER JOIN overall_rate ON 1 = 1
    WHERE
        status != 'Closed'
    ORDER BY
        ((prior_weight + 1) / (prior_weight / rate + julianday (last_checked_at) - julianday (updated_at))) * (julianday ('now') - julianday (last_checked_at)) DESC
    LIMIT 5000) t


