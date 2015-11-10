create or replace package sentiment_ninja

as

	/** This is a plsql implementation of the AFINN sentiment analysis dictionary
	* @author Morten Egan
	* @version 0.0.1
	* @project SENTIMENT_NINJA
	*/
	p_version		varchar2(50) := '0.0.1';

	type str_tokens is table of varchar2(32000);

	sentiment_comparative		number;
	sentiment_score				number;

	/** Tokenize a word
	* @author Morten Egan
	* @param string The string to tokenize
	* @return str_tokens The pipelined table return
	*/
	function tokenize (
		string						in				varchar2
	)
	return str_tokens
	pipelined;

	/** Get a sentiment analysis of a string
	* @author Morten Egan
	* @param string The string we want to get a sentiment analysis of.
	* @return number The value result of the sentiment analysis. Positive sentiment > 0
	*/
	function sentiment (
		string						in				varchar2
	)
	return number;

end sentiment_ninja;
/