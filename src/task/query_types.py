
class QueryTypes:
    @staticmethod
    def WHEREScalarComparison(): 
        return "WHERE: scalar comparison"
    @staticmethod
    def WHEREQuantifiedScalarComparison(): 
        return "WHERE: Quantified scalar comparison"
    @staticmethod
    def WHEREAttAggComparison(): 
        return "WHERE: Attribute-aggregation comparison"
    @staticmethod
    def WHEREConstAggComparison(): 
        return "WHERE: Constant-aggregation comparison"
    @staticmethod
    def WHERESetMembershipCheckingWithIn(): 
        return "WHERE: Set membership checking (IN)"
    @staticmethod
    def WHERESetMembershipCheckingWithNotIn(): 
        return "WHERE: Set membership checking (NOT IN)"
    @staticmethod
    def WHEREExistentialCheckingWithExists(): 
        return "WHERE: Existential checking (EXISTS)"
    @staticmethod
    def WHEREExistentialCheckingWithNotExists(): 
        return "WHERE: Existential checking (NOT EXISTS)"
    @staticmethod
    def HAVINGAggScalarComparison(): 
        return "HAVING: Aggregation-scalar comparison"
    @staticmethod 
    def HAVINGAggQuantifiedScalarComparison(): 
        return "HAVING: Aggregation-quantified scalar comparison"
    @staticmethod
    def HAVINGAggAggComparison(): 
        return "HAVING: Aggregation-aggregation comparison"
    @staticmethod
    def HAVINGSetMembershipCheckingWithIn(): 
        return "HAVING: Set membership checking (IN)"
    @staticmethod
    def HAVINGSetMembershipCheckingWithNotIn(): 
        return "HAVING: Set membership checking (NOT IN)"
    @staticmethod
    def HAVINGExistentialCheckingWithExists(): 
        return "HAVING: Existential checking (EXISTS)"
    @staticmethod
    def HAVINGExistentialCheckingWithNotExists(): 
        return "HAVING: Existential checking (NOT EXISTS)"
    @staticmethod
    def FROMScalarSubQuery(): 
        return "FROM: Scalar SubQuery"
    @staticmethod
    def FROMAggSubQuery(): 
        return "FROM: Subquery with aggregation"
    @staticmethod
    def FROMNotScalarNotAggSubQuery(): 
        return "FROM: Not scalar and without aggregation"
