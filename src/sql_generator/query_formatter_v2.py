QUERY_KEYWORDS = ['SELECT', 'FROM', 'JOIN', 'ON', 'WHERE', 'AND', 'OR', 'GROUP BY', 'HAVING', 'ORDER BY', 'LIMIT', '(', ')', ',']

def format_query(sql):
    white_space_stack = []
    white_space = ''

    need_parse = True
    parse_keyword = 'SELECT'

    result_sql = ''
    one_line = ''
    remain_sql = sql

    cur_clause = ''

    while need_parse:
        idx = remain_sql.find(parse_keyword)
        


        


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
