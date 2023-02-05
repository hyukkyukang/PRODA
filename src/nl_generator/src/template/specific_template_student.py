# from SQL2Text.query_graph.queryGraph import Relation as R, Attribute as A
# from SQL2Text.query_graph.queryGraph import Edge as E, Join, Operation as Op
from query_graph import Relation as R, Attribute as A
from query_graph import Edge as E, Join, Operation as Op
from src.query_graph.queryGraph import OperatorType

r_student = R("student")
a_s_stuid = A("student.stuID")
r_has_pet = R("has_pet")
a_hp_stuid = A("has_pet.stuID")
a_hp_petid = A("has_pet.petID")
r_pets = R("pets")
a_p_petid = A("pets.petID")

specific_templates = [
    {
        "path": [r_student, Join(r_student, a_s_stuid), a_s_stuid, Op(OperatorType.Equal, a_s_stuid, a_hp_stuid), \
                a_hp_stuid, Join(a_hp_stuid, r_has_pet), r_has_pet, Join(r_has_pet, a_hp_petid), a_hp_petid, \
                Op(OperatorType.Equal, a_hp_petid, a_p_petid), a_p_petid, Join(a_p_petid, r_pets), r_pets],
        "nl": ["who has pets"]
    },
    {
        "path": [r_pets, Join(r_pets, a_p_petid), a_p_petid, Op(OperatorType.Equal, a_p_petid, a_hp_petid), \
            a_hp_petid, Join(a_hp_petid, r_has_pet), r_has_pet, Join(r_has_pet, a_hp_stuid), a_hp_stuid, \
            Op(OperatorType.Equal, a_hp_stuid, a_s_stuid), a_s_stuid, Join(a_s_stuid, r_student), r_student],
        "nl": ["whose owner"]
    }
]
