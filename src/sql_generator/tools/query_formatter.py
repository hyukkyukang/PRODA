QUERY_KEYWORDS = ['SELECT', 'FROM', 'JOIN', 'ON', 'WHERE', 'AND', 'OR', 'GROUP BY', 'HAVING', 'ORDER BY', 'LIMIT', '(', ')', ',']

def format_query(sql):
    whitespace = ''
    line_whitespace = ''
    nesting_whitespace_stack = []
    line_nesting_whitespace_stack = []
    need_parse = True
    cur_phrase = ''
    parse_keyword = 'SELECT'
    result_sql = ''
    one_line = ''
    remain_sql = sql

    while need_parse:
        idx = remain_sql.find(parse_keyword)

        one_line += remain_sql[:idx]

        if parse_keyword not in ['(', ')', 'SELECT']:
            result_sql += ''.join(line_nesting_whitespace_stack) + line_whitespace + one_line + '\n'
            one_line = ''
            line_whitespace = whitespace
            line_nesting_whitespace_stack = nesting_whitespace_stack

        one_line += parse_keyword
        remain_sql = remain_sql[idx + len(parse_keyword):]


        if parse_keyword == 'JOIN':
            whitespace = ' ' * 5
        elif parse_keyword == 'ON':
            whitespace = ' ' * 7
        elif parse_keyword == 'AND':
            if cur_phrase == 'ON':
                whitespace = ' ' * 10
            elif cur_phrase == 'WHERE':
                whitespace = ' ' * 6
        elif parse_keyword == 'OR':
            whitespace = ' ' * 6
        elif parse_keyword in ['FROM', 'WHERE', 'GROUP BY', 'HAVING', 'ORDER BY', 'LIMIT']:
            whitespace = ''
        elif parse_keyword == ',':
            whitespace = ' ' * 7
        elif parse_keyword in ['(', 'SELECT']:
            nesting_whitespace_stack.append(' ' * idx)
        elif parse_keyword == ')':
            nesting_whitespace_stack.pop()

        if parse_keyword in ['ON', 'WHERE']:
            cur_phrase = parse_keyword

        need_parse = False
        min_keyword_idx = len(remain_sql)
        for keyword in QUERY_KEYWORDS:
            if keyword in remain_sql:
                need_parse = True
                key_idx = remain_sql.find(keyword)
                if key_idx < min_keyword_idx:
                    parse_keyword = keyword
                    min_keyword_idx = key_idx

    return result_sql
 
if __name__ == '__main__':
    sql = 'SELECT title.imdb_id, role_type.role, movie_info.id, movie_companies.id, movie_info_idx.movie_id, kind_type.id, aka_name.id, aka_title.season_nr, complete_cast.status_id FROM aka_name an JOIN aka_title at JOIN cast_info ci JOIN char_name ch_n JOIN complete_cast cc JOIN kind_type kt JOIN movie_companies mc JOIN movie_info mi JOIN movie_info_idx mi_idx JOIN name n JOIN role_type rt JOIN title t ON ci.person_id=n.id AND ci.person_role_id=ch_n.id AND ci.role_id=rt.id AND n.id=an.person_id AND t.id=at.movie_id AND t.id=cc.movie_id AND t.id=ci.movie_id AND t.id=mc.movie_id AND t.id=mi.movie_id AND t.id=mi_idx.movie_id AND t.kind_id=kt.id WHERE (title.md5sum NOT_IN ("f72e8a54bbf839002ded22c59b839b1c","4209d47afbb079f9ec7b2814250f550e","628719c75980703439d16e67a42cb750") OR char_name.md5sum = (SELECT COUNT(char_name.md5sum) FROM aka_name an JOIN aka_title at JOIN cast_info ci JOIN char_name ch_n JOIN comp_cast_type cct JOIN company_name cn JOIN company_type ct JOIN complete_cast cc JOIN info_type it JOIN kind_type kt JOIN movie_companies mc JOIN movie_info mi JOIN movie_info_idx mi_idx JOIN movie_keyword mk JOIN name n JOIN person_info pi JOIN role_type rt JOIN title t ON cct.id=cc.subject_id AND ci.person_id=n.id AND ci.person_role_id=ch_n.id AND ci.role_id=rt.id AND cn.id=mc.company_id AND ct.id=mc.company_type_id AND mi_idx.info_type_id=it.id AND n.id=an.person_id AND n.id=pi.person_id AND t.id=at.movie_id AND t.id=cc.movie_id AND t.id=ci.movie_id AND t.id=mc.movie_id AND t.id=mi.movie_id AND t.id=mi_idx.movie_id AND t.id=mk.movie_id AND t.kind_id=kt.id WHERE (title.phonetic_code != "N3546" OR char_name.name_pcode_nf = "N61")))'

    print(format_query(sql))
