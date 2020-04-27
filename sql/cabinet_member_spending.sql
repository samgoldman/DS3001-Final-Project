SELECT
	cb."Department",
	cb."President",
	cb."Nominee",
	cb."Votes for",
	cb."votes against",
	cb."days",
	SUM(CASE WHEN cc.country_code = 'USA' THEN ts.federal_action_obligation ELSE 0 END) AS domestic_spending,
	SUM(CASE WHEN cc.country_code NOT IN ('USA', 'NAN') THEN ts.federal_action_obligation ELSE 0 END) AS foreign_spending
	FROM "Cabinet Data - presidents" cb
	JOIN (Select period_of_performance_star::date, federal_action_obligation, legal_entity_country_code FROM transaction_fpds) ts
		ON ts.period_of_performance_star BETWEEN cb."Confirmed" AND cb."End date" JOIN ref_country_code cc
		ON (cc.country_name = ts.legal_entity_country_code or cc.country_code = ts.legal_entity_country_code)
	GROUP BY cb."Department", cb."President", cb."Nominee", cb."Votes for", cb."votes against", cb."days";
