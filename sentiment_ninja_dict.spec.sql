create or replace package sentiment_ninja_dict

as

	/** This is the AFINN-111 Dictionary
	* http://arxiv.org/abs/1103.2903
	* @author Morten Egan
	* @version 0.0.1
	* @project SENTIMENT_NINJA
	*/
	p_version		varchar2(50) := '0.0.1';

	type word_list	is table of number index by varchar2(100);
	afinn_dict		word_list;

end ;
/