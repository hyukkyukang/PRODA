import re
import abc
import networkx as nx
from src.query_graph.koutrika_query_graph import Query_graph, Relation, Attribute, Value, Function, FunctionType, OperatorType
from src.template.kourtrika_template import Generic_template, Template

def compare_string_without_newline(str1, str2):
    str1 = re.sub(' +', ' ', str1)
    str2= re.sub(' +', ' ', str2)
    return str1.replace("\n", "") == str2.replace("\n", "")

def query_graph_to_generic_templates(query_graph):
    """
        input: 
            - query_graph
        output: 
            - list of generic template graphs
        Assumption:
            - a relation must exists in a generic template
    """
    def get_all_paths(cur_relation, visited_edges):
        return get_all_outgoing_paths_to_adj_relations(cur_relation, visited_edges) + get_all_incoming_paths_from_adj_relations(cur_relation, visited_edges)

    def get_all_outgoing_paths_to_adj_relations(cur_relation, visited_edges):
        all_paths = []
        for src, dst in query_graph.out_edges(cur_relation):
            if (src, dst) not in visited_edges:
                visited_edges.append((src, dst))
                if isinstance(dst, Relation):
                    all_paths.append([(src, dst)])
                else:
                    rec_paths = get_all_paths(dst, visited_edges)
                    rec_paths = [[(src, dst)] + p for p in rec_paths] if rec_paths else [[(src, dst)]]
                    all_paths += rec_paths
        return all_paths
    
    def get_all_incoming_paths_from_adj_relations(cur_relation, visited_edges):
        all_paths = []
        for src, dst in query_graph.in_edges(cur_relation):
            if (src, dst) not in visited_edges:
                visited_edges.append((src, dst))
                if isinstance(dst, Relation):
                    all_paths.append([(src, dst)])
                else:
                    rec_paths = get_all_paths(dst, visited_edges)
                    rec_paths = [p + [(src, dst)] for p in rec_paths] if rec_paths else [[(src, dst)]]
                    all_paths += rec_paths
        return all_paths

    visited_edges = []
    generic_templates = []
    paths_for_generic_templates = []
    # Get all paths for generic templates
    for relation in query_graph.relations:
        paths_for_generic_templates += get_all_paths(relation, visited_edges)
    for path in paths_for_generic_templates:
        graph = Query_graph()
        for src, dst in path:
            edge = query_graph.edges[src, dst]['data']
            graph.unidirectional_connect(src, edge, dst)
        generic_template = Generic_template(graph, query_graph)
        print(generic_template.nl_description)
        generic_templates.append(generic_template)
    return generic_templates


# Templates
class Template_S_to_I(Template):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @property
    def nl_description(self):
        if self.DAG_to_QG:
            student_label = self.DAG_to_QG[self.student].label
            instructor_label = self.DAG_to_QG[self.instructors].label
            return f"{student_label} have been in classes of {instructor_label}"
        return "l(S) + have been in classes of + l(I)"

    @property
    def graph(self):
        if not Template_S_to_I._DAG:
            # Create Nodes
            self.student = Relation("Students")
            self.studentHistory = Relation("StudentHistory")
            self.courses = Relation("Courses")
            self.courseSched = Relation("CourseSched")
            self.instructors = Relation("Instructors")
            # Create DAG
            directed_acyclic_graph = Query_graph("DAG_Student-to-Instructors")
            directed_acyclic_graph.connect(self.student, self.studentHistory)
            directed_acyclic_graph.connect(self.studentHistory, self.courses)
            directed_acyclic_graph.connect(self.courses, self.courseSched)
            directed_acyclic_graph.connect(self.courseSched, self.instructors)
            Template_S_to_I._DAG = directed_acyclic_graph
        return Template_S_to_I._DAG

class Template_C_to_Val(Template):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @property
    def nl_description(self):
        if self.DAG_to_QG:
            val_label = self.DAG_to_QG[self.dep_name_val].label
            course_label = self.DAG_to_QG[self.courses].label
            return f"{val_label} {course_label}"
        return "l(val) + l(C)"

    @property
    def graph(self):
        if not Template_C_to_Val._DAG:
            # Create Nodes
            self.courses = Relation("Courses")
            self.departments = Relation("Departments")
            self.dep_name = Attribute("Name")
            self.dep_name_val = Value("")

            # Create DAG
            directed_acyclic_graph = Query_graph("DAG_Courses-to-name_val")
            directed_acyclic_graph.connect(self.courses, self.departments)
            directed_acyclic_graph.connect(self.departments, self.dep_name)
            directed_acyclic_graph.connect(self.dep_name, self.dep_name_val)
            Template_C_to_Val._DAG = directed_acyclic_graph
        return Template_C_to_Val._DAG

class Template_I_to_C(Template):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @property
    def nl_description(self):
        if self.DAG_to_QG:
            instructor_label = self.DAG_to_QG[self.instructors].label
            course_label = self.DAG_to_QG[self.courses].label
            val_label = self.DAG_to_QG[self.courseSched_term_val].label
            return f"{instructor_label} 's lectures on {course_label} in {val_label}"
        return "l(I) + 's lectures on + l(C) + in + l(val)"

    @property
    def graph(self):
        if not Template_I_to_C._DAG:
            # Create Nodes
            self.courses = Relation("Courses")
            self.courseSched = Relation("CourseSched")
            self.instructors = Relation("Instructors")
            self.courseSched_term = Attribute("Term")
            self.courseSched_term_val = Value("")

            # Create DAG
            directed_acyclic_graph = Query_graph("DAG_Instructors-to-Courses")
            directed_acyclic_graph.connect(self.instructors, self.courseSched)
            directed_acyclic_graph.connect(self.courseSched, self.courses)
            directed_acyclic_graph.connect(self.courseSched, self.courseSched_term)
            directed_acyclic_graph.connect(self.courseSched_term, self.courseSched_term_val)
            Template_I_to_C._DAG = directed_acyclic_graph
        return Template_I_to_C._DAG


# Queries
class Query(metaclass=abc.ABCMeta):
    # To cache graph
    _graph = None

    @property
    def generic_templates(self):
        if not hasattr(self, "_generic_templates"):
            self._generic_templates = query_graph_to_generic_templates(self.graph)
        return self._generic_templates

    @property
    @abc.abstractmethod
    def sql(self) -> str:
        pass
    
    @property
    @abc.abstractmethod
    def graph(self) -> Query_graph:
        pass
    
    @property
    @abc.abstractmethod
    def nl(self) -> str:
        pass

    @property
    @abc.abstractmethod
    def BST_nl(self) -> str:
        pass

    @property
    @abc.abstractmethod
    def MRP_nl(self) -> str:
        pass

    @property
    @abc.abstractmethod
    def TMT_nl(self) -> str:
        pass


class SPJ_query(Query):
    @property
    def sql(self):
        return """
            SELECT s.name, s.GPA, c.title, i.name, co.text
            FROM students s, comments co, student history h, courses c, departments d, coursesched cs, instructors i
            WHERE s.suid = co.suid AND
                s.suid = h.suid AND
                h.courseid = c.courseid AND
                c.depid = d.depid AND
                c.courseid = cs.courseid AND
                cs.instrid = i.instrid AND
                s.class = 2011 AND
                co.rating > 3 AND
                cs.term = 'spring' AND
                d.name = 'CS'
            """
    
    @property
    def graph(self):
        if not SPJ_query._graph:
            # Relation
            comments = Relation("Comments")
            students = Relation("Students")
            studentHistory = Relation("StudentHistory")
            departments = Relation("Departments")
            courses = Relation("Courses")
            courseSched = Relation("CourseSched")
            instructors = Relation("Instructors")

            # Attribute
            comments_text = Attribute("Text")
            comments_rating = Attribute("Rating")
            comments_stuid = Attribute("comments.Stuid", "StuID")

            students_name = Attribute("Student.Name", "name")
            students_gpa = Attribute("Student.GPA", "GPA")
            students_class = Attribute("Student.Class", "Class")
            students_stuid1 = Attribute("stuID1", "stuID")
            students_stuid2 = Attribute("stuID2", "stuID")

            studentHistory_stuid = Attribute("stuID3", "StuID")
            studentHistory_courseid = Attribute("studenthistory.CourseID", "CourseID")

            courses_courseid1 = Attribute("coursese.CourseID1", "CourseID")
            courses_courseid2 = Attribute("coursese.CourseID2", "CourseID")
            courses_title = Attribute("Title")
            courses_depid = Attribute("courses.DepID", "DepID")

            departments_depid = Attribute("DepID")
            departments_name = Attribute("deparment.Name", "Name")

            courseSched_courseid = Attribute("courseSched.CourseID", "CourseID")
            courseSched_instrid = Attribute("courseSched.InstrID", "InstrID")
            courseSched_term = Attribute("Term")

            instructors_name = Attribute("instructors.Name", "Name")
            instructors_instrid = Attribute("instructors.InstrID", "InstrID")

            # Values
            v_3 = Value("3")
            v_2011 = Value("2011")
            v_cs = Value("CS")
            v_spring = Value("Spring")

            query_graph = Query_graph("SPJ query")
            query_graph.connect_membership(comments, comments_text)
            query_graph.connect_selection(comments, comments_rating)
            query_graph.connect_predicate(comments_rating, v_3)

            query_graph.connect_join(comments, comments_stuid, students_stuid1, students)
            
            query_graph.connect_membership(students, students_name)
            query_graph.connect_membership(students, students_gpa)
            query_graph.connect_selection(students, students_class)
            query_graph.connect_predicate(students_class, v_2011)

            query_graph.connect_join(students, students_stuid2, studentHistory_stuid, studentHistory)
            query_graph.connect_join(studentHistory, studentHistory_courseid, courses_courseid1, courses)
            query_graph.connect_membership(courses, courses_title)
            
            query_graph.connect_join(courses, courses_depid, departments_depid, departments)
            query_graph.connect_selection(departments, departments_name)
            query_graph.connect_predicate(departments_name, v_cs)

            query_graph.connect_join(courses, courses_courseid2, courseSched_courseid, courseSched)
            query_graph.connect_selection(courseSched, courseSched_term)
            query_graph.connect_predicate(courseSched_term, v_spring)
            
            query_graph.connect_join(courseSched, courseSched_instrid, instructors_instrid, instructors)
            query_graph.connect_membership(instructors, instructors_name)
            SPJ_query._graph = query_graph
        return SPJ_query._graph

    @property
    def simplified_graph(self):
        if not SPJ_query._graph:
            # Relation
            comments = Relation("Comments", "comments")
            students = Relation("Students", "students")
            studentHistory = Relation("StudentHistory", "")
            departments = Relation("Departments", "departments")
            courses = Relation("Courses", "courses")
            courseSched = Relation("CourseSched", "")
            instructors = Relation("Instructors", "instructors")

            # Attribute
            comments_text = Attribute("Text", "description")
            comments_rating = Attribute("Rating")
            students_name = Attribute("students.Name", "name")
            students_gpa = Attribute("GPA", "gpa")
            students_class = Attribute("students.class", "class")
            courses_title = Attribute("Title", "title")
            departments_name = Attribute("departments.Name", "name")
            courseSched_term = Attribute("Term", "term")
            instructors_name = Attribute("instructors.Name", "name")

            # Values
            v_3 = Value("3")
            v_2011 = Value("2011")
            v_cs = Value("CS")
            v_spring = Value("Spring", "spring")

            query_graph = Query_graph("SPJ query")
            query_graph.connect_membership(comments, comments_text)
            query_graph.connect_selection(comments, comments_rating)
            query_graph.connect_predicate(comments_rating, v_3, operator=OperatorType.GreaterThan)

            # query_graph.connect(comments, students, "are given by", "gave")
            query_graph.connect_simplified_join(comments, students, "are given by", "gave")
            
            query_graph.connect_membership(students, students_gpa)
            query_graph.connect_membership(students, students_name)
            query_graph.connect_selection(students, students_class)
            query_graph.connect_predicate(students_class, v_2011)
            
            query_graph.connect_simplified_join(courses, courseSched, "are taught by", "")
            # query_graph.connect(courses, courseSched)
            query_graph.connect_selection(courseSched, courseSched_term)
            query_graph.connect_predicate(courseSched_term, v_spring)

            query_graph.connect_simplified_join(courseSched, instructors, "", "teach")
            # query_graph.connect(courseSched, instructors)
            query_graph.connect_membership(instructors, instructors_name)
            
            query_graph.connect_simplified_join(courses, departments, "are offered", "offer")
            query_graph.connect_selection(departments, departments_name)
            query_graph.connect_predicate(departments_name, v_cs)

            query_graph.connect_simplified_join(students, studentHistory, "have taken", "")
            # query_graph.connect(students, studentHistory)
            query_graph.connect_simplified_join(studentHistory, courses, "", "taken by")
            # query_graph.connect(studentHistory, courses)
            query_graph.connect_membership(courses, courses_title)
            
            SPJ_query._graph = query_graph
        return SPJ_query._graph

    @property
    def specific_templates(self):
        if not hasattr(self, "_specific_templates"):
            self._specific_templates = [Template_S_to_I(self.graph), Template_C_to_Val(self.graph), Template_I_to_C(self.graph)]
        return self._specific_templates

    @property
    def templates(self):
        return self.specific_templates + self.generic_templates
    
    @property
    def template_set(self):
        raise NotImplementedError("Need to add gold for template set")
        return None

    @property
    def nl(self):
        return self.BST_nl

    @property
    def BST_nl(self) -> str:
        return """
            Find the titles of course, the names and gpas of student, the descriptions of comments, and the names of instructor, for course taken by , 
            for associated with student, for student gave comments, for course are offered department and are taught by, 
            and for teach instructor. Consider only student whose class is 2011, 
            comments whose rating is greater than 3, department whose name is cs, and whose term is spring.
            """

    @property
    def MRP_nl(self) -> str:
        return "find title of courses in which courses are offered departments and name of departments is cs, gpa and name of students in which students have taken courses and class of students is 2011, description of comments in which comments are given by students and rating of comments is greater than 3, name of instructors in which instructors teach courses and term is spring."

    @property
    def TMT_nl(self) -> str:
        return """
            Find the gpa and name of students whose class is 2011 and have been in classes of instructors 
            and find the name of these instructors, whose lectures on courses are in spring and find the
            title of these CS courses and the description of comments whose rating is greater than 3
            given by these students
            """


class GroupBy_query(Query):
    
    @property
    def sql(self):
        return """  SELECT year, term, max(grade)
                    FROM studentHistory
                    GROUP BY year, term
                    HAVING avg(grade) > 3
               """
    
    @property
    def graph(self):
        if not GroupBy_query._graph:
            # Relation
            studentHistory = Relation("StudentHistory", "student history")

            # Attribute
            year_prj = Attribute("year")
            year_grp = Attribute("year")
            term_prj = Attribute("term")
            term_grp = Attribute("term")
            grade1 = Attribute("grade")
            grade2 = Attribute("grade")
            avg = Function(FunctionType.Avg)
            max = Function(FunctionType.Max)
            v_3 = Value("3")

            query_graph = Query_graph("group-by query")
            query_graph.connect_membership(studentHistory, grade1)
            query_graph.connect_transformation(max, grade1)
            query_graph.connect_grouping(studentHistory, year_grp)
            query_graph.connect_grouping(year_grp, term_grp)
            query_graph.connect_membership(studentHistory, year_prj)
            query_graph.connect_membership(studentHistory, term_prj)
            query_graph.connect_having(studentHistory, grade2)
            query_graph.connect_transformation(grade2, avg)
            query_graph.connect_predicate(avg, v_3)
            GroupBy_query._graph = query_graph
        return GroupBy_query._graph


    @property
    def simplified_graph(self):
        if not GroupBy_query._graph:
            # Relation
            studentHistory = Relation("StudentHistory", "student history")

            # Attribute
            year_prj = Attribute("year_p", "year")
            year_grp = Attribute("year_g", "year")
            term_prj = Attribute("term_p", "term")
            term_grp = Attribute("term_g", "term")
            grade1 = Attribute("grade_p", "grade")
            grade2 = Attribute("grade_h", "grade")
            avg = Function(FunctionType.Avg)
            max = Function(FunctionType.Max)
            v_3 = Value("3")

            query_graph = Query_graph("group-by query")
            query_graph.connect_membership(studentHistory, grade1)
            query_graph.connect_transformation(max, grade1)
            query_graph.connect_grouping(studentHistory, year_grp)
            query_graph.connect_grouping(year_grp, term_grp)
            query_graph.connect_membership(studentHistory, year_prj)
            query_graph.connect_membership(studentHistory, term_prj)
            query_graph.connect_having(studentHistory, grade2)
            query_graph.connect_transformation(grade2, avg)
            query_graph.connect_predicate(avg, v_3, OperatorType.GreaterThan)
            GroupBy_query._graph = query_graph
        return GroupBy_query._graph
    
    @property
    def nl(self):
        return " "

    @property
    def BST_nl(self) -> str:
        return """ """

    @property
    def MRP_nl(self) -> str:
        return 'find maximum grade, year, and term of student history for each year and term of student history, considering only those groups whose average grade of student history is greater than 3.'

    @property
    def TMT_nl(self) -> str:
        return """ """

class Nested_with_correlation_query(Query):
    @property
    def sql(self):
        return """
            SELECT s.name FROM student s WHERE NOT EXISTS (SELECT * FROM student s2 WHERE s2.GPA > s.GPA)
            """

    @property
    def graph(self):
        if not Nested_with_correlation_query._graph:
            # Relation
            students = Relation("students", "students")
            students2 = Relation("students", "students","S2")

            # Attribute
            name = Attribute("name", "name")
            gpa1 = Attribute("GPA_out", "GPA")
            gpa2 = Attribute("GPA_in", "GPA")
            star_node1 = Attribute("*_out", "all")
            star_node2 = Attribute("*_in", "all")

            # Query graph
            query_graph = Query_graph("nested query")
            query_graph.connect_membership(students, name)
            query_graph.connect_selection(gpa1, students)
            query_graph.connect_selection(students2, gpa2)
            query_graph.connect_selection(students, star_node1)
            query_graph.connect_predicate(star_node1, star_node2, OperatorType.NotExists)
            query_graph.connect_selection(star_node2, students2)
            query_graph.connect_predicate(gpa2, gpa1, OperatorType.GreaterThan)
            Nested_with_correlation_query._graph = query_graph
        return Nested_with_correlation_query._graph

    @property
    def simplified_graph(self):
        if not Nested_with_correlation_query._graph:
            # Relation
            students = Relation("students_out", "students", "S1")
            students2 = Relation("students_in", "students", "S2")

            # Attribute
            name = Attribute("name", "name")
            gpa1 = Attribute("GPA_out", "gpa")
            gpa2 = Attribute("GPA_in", "gpa")
            star_node1 = Attribute("*_out", " ")
            star_node2 = Attribute("*_in", " ")

            # Query graph
            query_graph = Query_graph("Correlated nested query")
            query_graph.connect_membership(students, name)
            query_graph.connect_selection(gpa1, students)
            query_graph.connect_selection(students2, gpa2)
            query_graph.connect_selection(students, star_node1)
            query_graph.connect_predicate(star_node1, star_node2, OperatorType.NotExists)
            query_graph.connect_membership(students2, star_node2)
            # query_graph.connect_selection(star_node2, students2)
            query_graph.connect_predicate(gpa2, gpa1, OperatorType.GreaterThan)
            Nested_with_correlation_query._graph = query_graph
        return Nested_with_correlation_query._graph

    @property
    def nl(self):
        return ""

    @property
    def BST_nl(self) -> str:
        return """
            """

    @property
    def MRP_nl(self) -> str:
        return "find name of students where there not exists students where gpa of students is greater than gpa of those students."

    @property
    def TMT_nl(self) -> str:
        return """
            """

class Nested_with_multisublink_query(Query):
    @property
    def sql(self):
        return """
            SELECT m1.id FROM MOVIE m1 JOIN rating r1 ON m1.id = r1.mov_id
            WHERE rating.stars < (SELECT MAX(r2.stars) 
                                    FROM movie m2 JOIN rating r2 ON m2.id = r2.mov_id 
                                    WHERE m2.id = m1.id)
                AND
                m1.id IN (SELECT m3.id 
                            FROM movie m3 JOIN direction md 
                            ON m3.id = md.mov_id JOIN director d ON md.dir_id = d.id 
                            WHERE d.first_name = "Spielberg" AND d.last_name = "Steven")
            GROUP BY m1.id
            HAVING AVG(r1.stars) >= 3
            """

    @property
    def graph(self):
        if not Nested_with_multisublink_query._graph:
            # Relation
            movie1 = Relation("movie1", "movie", "m1")
            movie2 = Relation("movie2", "movie", "m2")
            movie3 = Relation("movie3", "movie", "m3")
            rating1 = Relation("rating1", "rating", "r1")
            rating2 = Relation("rating2", "rating", "r2")
            direction = Relation("direction", "direction", "md")
            director = Relation("director", "director", "d")

            # Attribute
            m1_id1 = Attribute("m1_id1", "id")
            m1_id2 = Attribute("m1_id2", "id")
            m1_id3 = Attribute("m1_id3", "id")
            m1_id4 = Attribute("m1_id4", "id")
            m1_id5 = Attribute("m1_id5", "id")
            r1_stars1 = Attribute("r1_stars1", "stars")
            r1_stars2 = Attribute("r1_stars2", "stars")
            r2_stars = Attribute("r2_stars", "stars")
            r2_mov_id = Attribute("r2_mov_id", "mov_id")
            m2_id1 = Attribute("m2_id1", "id")
            m2_id2 = Attribute("m2_id2", "id")
            m3_id1 = Attribute("m3_id1", "id")
            m3_id2 = Attribute("m3_id2", "id")
            md_mov_id = Attribute("md_mov_id", "mov_id")
            dir_id = Attribute("dir_id", "id")
            d_id = Attribute("d_id", "id")
            first_name = Attribute("first_name", "first_name")
            last_name = Attribute("last_name", "last_name")

            # Function nodes
            f_avg = Function(FunctionType.Avg)
            f_max = Function(FunctionType.Max)
            
            # Values
            v_first_name = Value("Spielberg")
            v_last_name = Value("Steven")
            v_3 = Value("3")

            # Query graph
            query_graph = Query_graph("nested query2")
            query_graph.connect_membership(movie1, m1_id1)
            query_graph.connect_join(movie1, m1_id2, r1_stars1, rating1)
            query_graph.connect_selection(rating1, r1_stars1)
            query_graph.connect_predicate(r1_stars1, f_max, OperatorType.LessThan)

            # For nested query1
            query_graph.connect_transformation(r2_stars, f_max)
            query_graph.connect_membership(rating2, r2_stars)
            query_graph.connect_join(rating2, r2_mov_id, m2_id1, movie2)
            
            # For correlation
            query_graph.connect_selection(movie1,  m1_id3)
            query_graph.connect_predicate(m2_id2, m1_id3)
            
            # For second where clause
            query_graph.connect_selection(movie1, m1_id4)
            query_graph.connect_predicate(m1_id4, m3_id1, OperatorType.In)
            
            # For nested query2
            query_graph.connect_membership(movie3, m3_id1)
            query_graph.connect_join(movie3, m3_id2, md_mov_id, direction)
            query_graph.connect_join(direction, dir_id, d_id, director)
            query_graph.connect_selection(director, first_name)
            query_graph.connect_predicate(first_name, v_first_name)
            query_graph.connect_selection(director, last_name)
            query_graph.connect_predicate(last_name, v_last_name)
            
            # For grouping and having
            query_graph.connect_grouping(movie1, m1_id5)
            query_graph.connect_having(rating1, r1_stars2)
            query_graph.connect_transformation(r1_stars2, f_avg)
            query_graph.connect_predicate(f_avg, v_3, OperatorType.GEq)
            
            Nested_with_multisublink_query._graph = query_graph
        return Nested_with_multisublink_query._graph

    @property
    def simplified_graph(self):
        if not Nested_with_multisublink_query._graph:
            # Relation
            movie1 = Relation("movie1", "movie", "m1", is_primary=True)
            movie2 = Relation("movie2", "movie", "m2")
            movie3 = Relation("movie3", "movie", "m3")
            rating1 = Relation("rating1", "rating", "r1")
            rating2 = Relation("rating2", "rating", "r2")
            direction = Relation("direction", " ", "md")
            director = Relation("director", "director", "d")

            # Attribute
            m1_id1 = Attribute("m1_id1", "id")
            m1_id3 = Attribute("m1_id3", "id")
            m1_id4 = Attribute("m1_id4", "id")
            m1_id5 = Attribute("m1_id5", "id")
            r1_stars1 = Attribute("r1_stars1", " ")
            r1_stars2 = Attribute("r1_stars2", " ")
            r2_stars = Attribute("r2_stars", "")
            m2_id2 = Attribute("m2_id2", "id")
            m3_id1 = Attribute("m3_id1", "id")
            first_name = Attribute("first_name", "first_name")
            last_name = Attribute("last_name", "last_name")

            # Function nodes
            f_avg = Function(FunctionType.Avg)
            f_max = Function(FunctionType.Max)
            
            # Values
            v_first_name = Value("Spielberg")
            v_last_name = Value("Steven")
            v_3 = Value("3")

            # Query graph
            query_graph = Query_graph("Multiple sublink nested query")
            query_graph.connect_membership(movie1, m1_id1)
            query_graph.connect_simplified_join(movie1, rating1, "", "belongs to")

            query_graph.connect_selection(rating1, r1_stars1)
            query_graph.connect_predicate(r1_stars1, f_max, OperatorType.LessThan)

            # For nested query1
            query_graph.connect_transformation(f_max, r2_stars)
            query_graph.connect_membership(rating2, r2_stars)
            query_graph.connect_simplified_join(rating2, movie2, "belongs to", "")

            # For correlation
            query_graph.connect_selection(movie2, m2_id2)
            query_graph.connect_predicate(m2_id2, m1_id3)
            query_graph.connect_selection(m1_id3, movie1)

            # For second where clause
            query_graph.connect_selection(movie1, m1_id4)
            query_graph.connect_predicate(m1_id4, m3_id1, OperatorType.In)
            
            # For nested query2
            query_graph.connect_membership(movie3, m3_id1)
            query_graph.connect_simplified_join(movie3, direction)
            query_graph.connect_simplified_join(direction, director)
            query_graph.connect_selection(director, first_name)
            query_graph.connect_predicate(first_name, v_first_name)
            query_graph.connect_selection(director, last_name)
            query_graph.connect_predicate(last_name, v_last_name)
            
            # For grouping and having
            query_graph.connect_grouping(movie1, m1_id5)
            query_graph.connect_having(rating1, r1_stars2)
            query_graph.connect_transformation(r1_stars2, f_avg)
            query_graph.connect_predicate(f_avg, v_3, OperatorType.GEq)
            Nested_with_multisublink_query._graph = query_graph
        return Nested_with_multisublink_query._graph

    @property
    def nl(self):
        return ""

    @property
    def BST_nl(self) -> str:
        return """
            """

    @property
    def MRP_nl(self) -> str:
        return "find id of movie for each id of movie, considering only those groups whose average rating is greater than or equal to 3, where id of movie is in id of movie where first_name of director is spielberg and last_name of director is steven and rating is less than maximum rating in which rating belongs to movie of the same id."

    @property
    def TMT_nl(self) -> str:
        return """
            """

class Nested_with_groupby_query(Query):
    @property
    def sql(self):
        return """
            SELECT year, sum(revenue) FROM movie 
            WHERE genre = 'romance'
            AND rating IN (SELECT AVG(rating) FROM movie
                            WHERE year = 2020
                            GROUP BY directors)
            GROUP BY year
            """

    @property
    def graph(self):
        raise NotImplementedError("Graph of Nested query 3 is not implemented yet")

    @property
    def simplified_graph(self):
        if not Nested_with_groupby_query._graph:
            # Relation
            movie1 = Relation("movie1", "movie", "m1", is_primary=True)
            movie2 = Relation("movie2", "movie", "m2")

            # Attribute
            year1 = Attribute("year1", "year")
            revenue = Attribute("revenue", "revenue")
            genre = Attribute("genre", "genre")
            rating1 = Attribute("rating1", "rating")
            rating2 = Attribute("rating2", "rating")
            year2 = Attribute("year2", "year")
            director = Attribute("director", "director")
            year3 = Attribute("year3", "year")

            # Function
            f_sum = Function(FunctionType.Sum)
            f_avg = Function(FunctionType.Avg)

            # Value
            v_2020 = Value("2020")
            v_romance = Value("romance")

            # Query graph
            query_graph = Query_graph("Nested query with group by")
            query_graph.connect_membership(movie1, year1)
            query_graph.connect_membership(movie1, revenue)
            query_graph.connect_transformation(revenue, f_sum)
            query_graph.connect_selection(movie1, genre)
            query_graph.connect_predicate(genre, v_romance)
            query_graph.connect_selection(movie1, rating1)
            query_graph.connect_predicate(rating1, f_avg, OperatorType.In)
            query_graph.connect_transformation(f_avg, rating2)
            query_graph.connect_membership(movie2, rating2)
            query_graph.connect_selection(movie2, year2)
            query_graph.connect_predicate(year2, v_2020)
            query_graph.connect_grouping(movie2, director)
            query_graph.connect_grouping(movie1, year3)
            Nested_with_groupby_query._graph = query_graph
        return Nested_with_groupby_query._graph

    @property
    def nl(self):
        return ""

    @property
    def BST_nl(self) -> str:
        return """
            """

    @property
    def MRP_nl(self) -> str:
        return "find year and revenue of movie for each year of movie where genre of movie is romance and rating of movie is in average rating of movie for each director of movie where year of movie is 2020."

    @property
    def TMT_nl(self) -> str:
        return """
            """

class Nested_with_multilevel_query(Query):
    @property
    def sql(self):
        return """SELECT id, name FROM movie WHERE 
                genre IN (SELECT genre FROM movie 
                        WHERE director = 'Spielberg' AND 
                        revenu < (SELECT Max(revenu) FROM movie WHERE director = 'Nolan')
                )"""

    @property
    def graph(self):
        raise NotImplementedError("Graph of Nested query 3 is not implemented yet")

    @property
    def simplified_graph(self):
        if not Nested_with_multilevel_query._graph:
            # Relations
            movie1 = Relation("movie1", "movie", "m1", is_primary=True)
            movie2 = Relation("movie2", "movie", "m2")
            movie3 = Relation("movie3", "movie", "m3")
            
            # Attributes
            id = Attribute("id", "id")
            name = Attribute("name", "name")
            genre1 = Attribute("genre1", "genre")
            genre2 = Attribute("genre2", "genre")
            director1 = Attribute("director1", "director")
            revenue1 = Attribute("revenue1", "revenue")
            revenue2 = Attribute("revenue2", "revenue")
            director2 = Attribute("director2", "director")
            
            # Functions
            f_max = Function(FunctionType.Max)
            
            # Values
            v_spielberg = Value("Spielberg")
            v_nolan = Value("Nolan")
            
            # Query graph
            query_graph = Query_graph("Multi-level nested query")
            query_graph.connect_membership(movie1, id)
            query_graph.connect_membership(movie1, name)
            query_graph.connect_selection(movie1, genre1)
            
            query_graph.connect_predicate(genre1, genre2, OperatorType.In)
            
            # Level 1 nested query
            query_graph.connect_membership(movie2, genre2)
            query_graph.connect_selection(movie2, director1)
            query_graph.connect_predicate(director1, v_spielberg)
            query_graph.connect_selection(movie2, revenue1)
            
            query_graph.connect_predicate(revenue1, f_max, OperatorType.LessThan)
            
            # Level 2 nested query
            query_graph.connect_transformation(f_max, revenue2)
            query_graph.connect_membership(movie3, revenue2)
            query_graph.connect_selection(movie3, director2)
            query_graph.connect_predicate(director2, v_nolan)
            
            Nested_with_multilevel_query._graph = query_graph
        return Nested_with_multilevel_query._graph

    @property
    def nl(self):
        return ""

    @property
    def BST_nl(self) -> str:
        return """
            """

    @property
    def MRP_nl(self) -> str:
        return "Find id and name of movie where genre of movie is in genre of movie where director of movie is spielberg and revenue of movie is less than maximum revenue of movie where director of movie is nolan."

    @property
    def TMT_nl(self) -> str:
        return """
            """
