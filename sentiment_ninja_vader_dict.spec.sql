create or replace package sentiment_ninja_vader_dict

as

	/** Sentiment dictionary based on Vadersentiment
	* https://github.com/cjhutto/vaderSentiment
	* @author Morten Egan
	* @version 0.0.1
	* @project SENTIMENT_NINJA
	*/
	p_version		varchar2(50) := '0.0.1';

	type word_list	is table of number index by varchar2(100);
	vader_dict		word_list;

end sentiment_ninja_vader_dict;
/