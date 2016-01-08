create or replace package body sentiment_ninja

as

	function tokenize (
		string						in				varchar2
	)
	return str_tokens
	pipelined
	
	as

		cursor get_tokens is
			select 
				regexp_substr(string, '[^[:space:]]+', 1, level) as word
			from 
				dual
			connect by level <= length(regexp_replace(string,'[^[:space:]]+'))+1;
	
	begin
	
		dbms_application_info.set_action('tokenize');

		for words in get_tokens loop
			pipe row(words.word);
		end loop;
	
		dbms_application_info.set_action(null);
	
		return;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end tokenize;

	function afinn_sentiment (
		string						in				varchar2
	)
	return number
	
	as
	
		l_ret_val			number := 0;
		l_token_count		number := 0;
		l_positive			number := 0;
		l_negative			number := 0;
		l_comparative		number := 0;

		cursor split_string is
			select rownum, column_value from table(tokenize(string));
	
	begin
	
		dbms_application_info.set_action('afinn_sentiment');

		for token in split_string loop
			l_token_count := token.rownum;
			if sentiment_ninja_dict.afinn_dict.exists(token.column_value) then
				if sentiment_ninja_dict.afinn_dict(token.column_value) > 0 then
					l_positive := l_positive + 1;
				else
					l_negative := l_negative + 1;
				end if;
				l_ret_val := l_ret_val + sentiment_ninja_dict.afinn_dict(token.column_value);
			end if;
		end loop;

		if l_token_count > 0 then
			sentiment_comparative := l_ret_val/l_token_count;
		end if;

		sentiment_score := l_ret_val;
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end afinn_sentiment;

	function vader_sentiment (
		string						in				varchar2
	)
	return number
	
	as
	
		l_ret_val			number := 0;
	
	begin
	
		dbms_application_info.set_action('vader_sentiment');
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end vader_sentiment;

	function sentiment (
		string						in				varchar2
		, sentiment_engine			in				varchar2 default 'AFINN'
	)
	return number
	
	as
	
		l_ret_val					number := 0;
	
	begin
	
		dbms_application_info.set_action('sentiment');

		if sentiment_engine = 'AFINN' then
			l_ret_val := afinn_sentiment(string);
		elsif sentiment_engine = 'VADER' then
			l_ret_val := vader_sentiment(string);
		end if;
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end sentiment;

	function is_positive (
		string						in				varchar2
	)
	return boolean
	
	as
	
		l_ret_val			boolean := false;
	
	begin
	
		dbms_application_info.set_action('is_positive');

		if sentiment(string) > 0 then
			l_ret_val := true;
		end if;
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end is_positive;

	function is_negative (
		string						in				varchar2
	)
	return boolean
	
	as
	
		l_ret_val			boolean;
	
	begin
	
		dbms_application_info.set_action('is_negative');

		if sentiment(string) < 0 then
			l_ret_val := true;
		end if;
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end is_negative;

begin

	dbms_application_info.set_client_info('sentiment_ninja');
	dbms_session.set_identifier('sentiment_ninja');

end sentiment_ninja;
/