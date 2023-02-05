from src.query_graph import OperatorType, AggregationType
from src.query_graph import Relation, Attribute, Value, Function, Query_graph
# from SQL2Text.query_graph.queryGraph import Relation, Attribute, Value, Function, Query_graph
# from SQL2Text.query_graph.queryGraph import OperatorType, AggregationType


def query_graph_for_simple_selection():
    # Nodes
    r_student = Relation("student")
    r_has_pet = Relation("has_pet")
    r_pets = Relation("pets")
    a_s_stuID1 = Attribute("student.stuID")
    a_s_stuID2 = Attribute("student.stuID")
    a_hs_stuID = Attribute("has_pet.stuID")
    a_hs_petID = Attribute("has_pet.petID")
    a_pets_petID = Attribute("pets.petID")
    a_pets_pet_age = Attribute("pets.pet_age")
    v_10 = Value(10)

    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_stuID1)
    query_graph.connect_join(r_student, a_s_stuID2, a_hs_stuID, r_has_pet)
    query_graph.connect_join(r_has_pet, a_hs_petID, a_pets_petID, r_pets)
    query_graph.connect_selection(r_pets, a_pets_pet_age)
    query_graph.connect_operation(a_pets_pet_age, OperatorType.Lessthan, v_10)
    query_graph.set_join_directions()

    return query_graph

def query_graph_for_multi_projection():
    # Nodes
    r_student = Relation("student")
    r_has_pet = Relation("has_pet")
    r_pets = Relation("pets")
    a_s_Lname = Attribute("student.Lname")
    a_s_Fname = Attribute("student.Fname")
    a_s_stuID = Attribute("student.stuID")
    a_hs_stuID = Attribute("has_pet.stuID")
    a_hs_petID = Attribute("has_pet.petID")
    a_pets_petID = Attribute("pets.petID")
    a_pets_pet_age = Attribute("pets.pet_age")
    v_10 = Value(10)

    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_Lname)
    query_graph.connect_projection(r_student, a_s_Fname)
    query_graph.connect_join(r_student, a_s_stuID, a_hs_stuID, r_has_pet)
    query_graph.connect_join(r_has_pet, a_hs_petID, a_pets_petID, r_pets)
    query_graph.connect_selection(r_pets, a_pets_pet_age)
    query_graph.connect_operation(a_pets_pet_age, OperatorType.Lessthan, v_10)
    query_graph.set_join_directions()
    return query_graph

def query_graph_for_multi_projection_and_selection():
    # Nodes
    r_student = Relation("student")
    r_has_pet = Relation("has_pet")
    r_pets = Relation("pets")
    a_s_Lname = Attribute("student.Lname")
    a_s_Fname = Attribute("student.Fname")
    a_s_major = Attribute("student.major")
    a_s_stuID = Attribute("student.stuID")
    a_hs_stuID = Attribute("has_pet.stuID")
    a_hs_petID = Attribute("has_pet.petID")
    a_pets_petID = Attribute("pets.petID")
    a_pets_pet_age = Attribute("pets.pet_age")
    v_10 = Value(10)
    computer_science = Value("computer science")
    
    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_Lname)
    query_graph.connect_projection(r_student, a_s_Fname)
    query_graph.connect_selection(r_student, a_s_major)
    query_graph.connect_operation(a_s_major, OperatorType.Equal, computer_science)
    query_graph.connect_join(r_student, a_s_stuID, a_hs_stuID, r_has_pet)
    query_graph.connect_join(r_has_pet, a_hs_petID, a_pets_petID, r_pets)
    query_graph.connect_selection(r_pets, a_pets_pet_age, operation_idx=1)
    query_graph.connect_operation(a_pets_pet_age, OperatorType.Lessthan, v_10)
    query_graph.set_join_directions()
    return query_graph

def query_graph_for_correlation():
    # Nodes
    r_student1 = Relation("student")
    r_has_pet1 = Relation("has_pet")
    r_pets1 = Relation("pets")
    a_s_Lname = Attribute("student.Lname")
    a_s_Fname = Attribute("student.Fname")
    a_s_stuID1 = Attribute("student.stuID")
    a_hs_stuID1 = Attribute("has_pet.stuID")
    a_hs_petID1 = Attribute("has_pet.petID")
    a_pets_petID1 = Attribute("pets.petID")
    a_pets_pet_age = Attribute("pets.pet_age")
    a_pets_pet_type1 = Attribute("pets.pet_type")
    v_10 = Value(10)

    r_student2 = Relation("student", nesting_level=1)
    r_has_pet2 = Relation("has_pet", nesting_level=1)
    r_pets2 = Relation("pets", nesting_level=1)
    a_s_stuID2_1 = Attribute("student.stuID", nesting_level=1)
    a_s_stuID2_2 = Attribute("student.stuID", nesting_level=1)
    a_hs_stuID2 = Attribute("has_pet.stuID", nesting_level=1)
    a_hs_petID2 = Attribute("has_pet.petID", nesting_level=1)
    a_pets_petID2 = Attribute("pets.petID", nesting_level=1)
    a_pets_pet_type2 = Attribute("pets.pet_type", nesting_level=1)
    a_s_advisor = Attribute("student.advisor", nesting_level=1)
    
    # Connect Nodes
    # Outer query
    query_graph = Query_graph()
    query_graph.connect_projection(r_student1, a_s_Lname)
    query_graph.connect_projection(r_student1, a_s_Fname)
    query_graph.connect_join(r_student1, a_s_stuID1, a_hs_stuID1, r_has_pet1)
    query_graph.connect_join(r_has_pet1, a_hs_petID1, a_pets_petID1, r_pets1)
    query_graph.connect_selection(r_pets1, a_pets_pet_age)
    query_graph.connect_operation(a_pets_pet_age, OperatorType.Lessthan, v_10)
    # Inner query
    query_graph.connect_selection(r_pets1, a_pets_pet_type1, operation_idx=1)
    query_graph.connect_operation(a_pets_pet_type1, OperatorType.In, a_pets_pet_type2)
    query_graph.connect_projection(a_pets_pet_type2, r_pets2)
    query_graph.connect_join(r_student2, a_s_stuID2_2, a_hs_stuID2, r_has_pet2)
    query_graph.connect_join(r_has_pet2, a_hs_petID2, a_pets_petID2, r_pets2)
    query_graph.connect_selection(r_student2, a_s_stuID2_1)
    query_graph.connect_operation(a_s_stuID2_1, OperatorType.Equal, a_s_advisor)
    query_graph.connect_selection(a_s_advisor, r_student1)
    query_graph.set_join_directions()
    return query_graph

def query_graph_for_group_by_having():
    # Nodes
    r_student = Relation("student")
    r_has_pet = Relation("has_pet")
    r_pets = Relation("pets")
    
    a_s_stuID1 = Attribute("student.stuID")
    f_count = Function(AggregationType.Count)
    a_s_age = Attribute("student.age")
    v_10 = Value(10)
    
    a_s_stuID2 = Attribute("student.stuID")
    a_hs_stuID = Attribute("has_pet.stuID")
    a_hs_petID = Attribute("has_pet.petID")
    a_pets_petID = Attribute("pets.petID")
    a_pets_pet_type = Attribute("pets.petType")
    dummy_node = Attribute("pets.*")
    f_count2 = Function(AggregationType.Count)
    v_2 = Value(2)

    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_stuID1)
    query_graph.connect_aggregation(a_s_stuID1, f_count)
    query_graph.connect_selection(r_student, a_s_age)
    query_graph.connect_operation(a_s_age, OperatorType.Lessthan, v_10)
    query_graph.connect_join(r_student, a_s_stuID2, a_hs_stuID, r_has_pet)
    query_graph.connect_join(r_has_pet, a_hs_petID, a_pets_petID, r_pets)
    query_graph.connect_group(r_pets, a_pets_pet_type)
    query_graph.connect_having(r_pets, dummy_node)
    query_graph.connect_aggregation(dummy_node, f_count2)
    query_graph.connect_operation(f_count2, OperatorType.Lessthan, v_2)
    query_graph.set_join_directions()
    return query_graph

def query_graph_for_order_by_limit():
    # Nodes
    r_student = Relation("student")
    a_s_fname = Attribute("student.Fname")
    a_s_age = Attribute("age")
    v_10 = Value(10)
    
    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_fname)
    query_graph.connect_order(r_student, a_s_age, is_asc=True)
    query_graph.connect_limit(r_student, v_10)
    query_graph.set_join_directions()
    return query_graph

def query_graph_for_multi_predicate_with_or():# Nodes
    r_student = Relation("student")
    a_s_department1 = Attribute("student.department")
    a_s_department2 = Attribute("student.department")
    a_s_age1 = Attribute("student.age")
    a_s_age2 = Attribute("student.age")
    a_s_Fname = Attribute("student.Fname")
    v_25 = Value(25)
    v_20 = Value(20)
    v_computer_science = Value("computer science")
    v_creative_it = Value("creative IT")
    
    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_Fname)
    query_graph.connect_selection(r_student, a_s_department1, operation_idx=1)
    query_graph.connect_selection(r_student, a_s_department2, operation_idx=1)
    query_graph.connect_operation(a_s_department1, OperatorType.Equal, v_computer_science)
    query_graph.connect_operation(a_s_department2, OperatorType.Equal, v_creative_it)
    query_graph.connect_selection(r_student, a_s_age1, operation_idx=0)
    query_graph.connect_selection(r_student, a_s_age2, operation_idx=0)
    query_graph.connect_operation(a_s_age1, OperatorType.Lessthan, v_20)
    query_graph.connect_operation(a_s_age2, OperatorType.Greaterthan, v_25)
    query_graph.set_join_directions()
    return query_graph

def query_graph_for_multi_sublink_and_nested_sublink():
    # Nodes
    r_student1 = Relation("student")
    r_student2 = Relation("student", nesting_level=1)
    r_student3 = Relation("student", query_block_idx=1, nesting_level=1)
    r_has_pet = Relation("has_pet", query_block_idx=1, nesting_level=1)
    r_pets = Relation("pets", query_block_idx=1, nesting_level=1)
    a_s1_Fname = Attribute("student.Fname")
    a_s1_age = Attribute("student.age")
    a_s1_department = Attribute("student.department")
    f_avg = Function(AggregationType.Avg, nesting_level=1)
    a_s2_age = Attribute("student.age", nesting_level=1)
    a_s2_department = Attribute("student.department", nesting_level=1)
    a_s3_department = Attribute("student.department", query_block_idx=1, nesting_level=1)
    v_computer_science = Value("computer science", nesting_level=1)
    a_s3_stuID = Attribute("student.stuID", query_block_idx=1, nesting_level=1)
    a_hp_stuID = Attribute("has_pet.stuID", query_block_idx=1, nesting_level=1)
    a_hp_petID = Attribute("has_pet.petID", query_block_idx=1, nesting_level=1)
    a_p_petID = Attribute("pets.petID", query_block_idx=1, nesting_level=1)
    a_p_petType = Attribute("pets.petType", query_block_idx=1, nesting_level=1)
    v_dog = Value("dog", query_block_idx=1, nesting_level=1)

    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student1, a_s1_Fname)
    query_graph.connect_selection(r_student1, a_s1_age, operation_idx=0)
    query_graph.connect_operation(a_s1_age, OperatorType.Greaterthan, f_avg)
    query_graph.connect_aggregation(f_avg, a_s2_age)
    query_graph.connect_projection(a_s2_age, r_student2)
    query_graph.connect_selection(r_student2, a_s2_department)
    query_graph.connect_operation(a_s2_department, OperatorType.Equal, v_computer_science)
    query_graph.connect_selection(r_student1, a_s1_department, operation_idx=1)
    query_graph.connect_operation(a_s1_department, OperatorType.In, a_s3_department)
    query_graph.connect_projection(a_s3_department, r_student3)
    query_graph.connect_join(r_student3, a_s3_stuID, a_hp_stuID, r_has_pet)
    query_graph.connect_join(r_has_pet, a_hp_petID, a_p_petID, r_pets)
    query_graph.connect_selection(r_pets, a_p_petType)
    query_graph.connect_operation(a_p_petType, OperatorType.Equal, v_dog)
    query_graph.set_join_directions()
    return query_graph


def query_graph_for_multi_projection_from_different_relations():
    # Nodes
    r_student = Relation("student")
    r_has_pet = Relation("has_pet")
    r_pets = Relation("pets")
    a_s_name = Attribute("student.name")
    a_s_stuID = Attribute("student.stuID")
    a_hp_stuID = Attribute("has_pet.stuID")
    a_hp_petID = Attribute("has_pet.petID")
    a_p_petID = Attribute("pets.petID")
    a_s_department = Attribute("department")
    v_computer_scinece = Value("computer science")
    a_p_name = Attribute("pets.name")
    a_p_age = Attribute("pets.age")
    v_ten = Value(10)
    
    # Connect Nodes
    query_graph = Query_graph()
    query_graph.connect_projection(r_student, a_s_name)
    query_graph.connect_selection(r_student, a_s_department)
    query_graph.connect_operation(a_s_department, OperatorType.Equal, v_computer_scinece)
    query_graph.connect_join(r_student, a_s_stuID, a_hp_stuID, r_has_pet)
    query_graph.connect_join(r_has_pet, a_hp_petID, a_p_petID, r_pets)
    query_graph.connect_projection(r_pets, a_p_name)
    query_graph.connect_selection(r_pets, a_p_age, operation_idx=1)
    query_graph.connect_operation(a_p_age, OperatorType.Greaterthan, v_ten)
    query_graph.set_join_directions()
    return query_graph
