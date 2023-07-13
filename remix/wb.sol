SELECT
	count(*) AS proofs,
	hex(tx_sender) AS refiner_operator,
	toStartOfInterval(signed_at, INTERVAL 30 MINUTE) AS interval_start
FROM
	blockchains.all_chains
WHERE
	chain_name = 'moonbeam_moonbase_alpha'
	
	--please enter your "Operator" address in this filter. Remove the '0x' at the beginning
	AND tx_sender = unhex('B4B45128F9a5fa45545516A071527d21247438F6')
	
	--topic hash for 'BlockResultProductionProofSubmitted'
	AND topic0 = unhex('a2fc857ac5e0a985c1ebe30de06f65e1ea75ec0dacdac91d9130492573fcccd0')
	
	AND signed_at >= now() - INTERVAL 3 HOUR
GROUP BY
	refiner_operator,
	interval_start
