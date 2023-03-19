import os
import attrs
import boto3
from hkkang_utils.misc import property_with_cache

IS_USE_SANDBOX = True

KANGHK2428_AWS_ACCESS_KEY_ID = "AKIAYRRBYHW4EQTXXL75"
KANGHK2428_AWS_SECRETE_ACCESS_KEY_ID = "NLKYtfjXcdY5f5qwOusUjZCp8COjuDHLEZNdCay/"
DEFAULT_ENDPOINT_URL = "https://mturk-requester.us-east-1.amazonaws.com"
SANDBOX_ENDPOINT_URL = "https://mturk-requester-sandbox.us-east-1.amazonaws.com"
ENDPOINT_URL = SANDBOX_ENDPOINT_URL if IS_USE_SANDBOX else DEFAULT_ENDPOINT_URL

__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))


@attrs.define
class MTurkClient:
    _client: boto3.client = attrs.field(init=False)
    # For building client
    region_name: str = attrs.field(default="us-east-1")
    aws_access_key_id: str = attrs.field(default=KANGHK2428_AWS_ACCESS_KEY_ID)
    aws_secret_access_key: str = attrs.field(default=KANGHK2428_AWS_SECRETE_ACCESS_KEY_ID)
    endpoint_url: str = attrs.field(default=ENDPOINT_URL)
    # For creating HIT
    _question = attrs.field(init=False)
    question_schema_path: str = attrs.field(default=os.path.join(__location__, "AMT_ExternalQuestion.xml"))
    reward = attrs.field(default="0.11")
    max_assignments: int = attrs.field(default=10)
    lifetime_in_seconds: int = attrs.field(default=60 * 30)
    assignment_duration_in_seconds: int = attrs.field(default=60 * 30)

    def __attrs_post_init__(self):
        self._client = boto3.client(
            service_name="mturk",
            endpoint_url=self.endpoint_url,
            region_name=self.region_name,
            aws_access_key_id=self.aws_access_key_id,
            aws_secret_access_key=self.aws_secret_access_key,
        )

    @property
    def worker_requirements(self):
        # Example of using qualification to restrict responses to Workers who have had
        # at least 80% of their assignments approved. See:
        # http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_QualificationRequirementDataStructureArticle.html#ApiReference_QualificationType-IDs
        return [
            {
                "QualificationTypeId": "000000000000000000L0",
                "Comparator": "GreaterThanOrEqualTo",
                "IntegerValues": [80],
                "RequiredToPreview": True,
            }
        ]

    @property_with_cache
    def question(self):
        # The question we ask the workers is contained in this file.
        return open(self.question_schema_path, "r").read()

    def get_account_balanace(self):
        return self._client.get_account_balance()["AvailableBalance"]

    def create_hit(self):
        response = self._client.create_hit(
            Title="Understanding the question intention",
            Keywords="question, answer, research, excel, query",
            Description="Answer a simple question",
            Reward=self.reward,
            MaxAssignments=self.max_assignments,
            LifetimeInSeconds=self.lifetime_in_seconds,
            AssignmentDurationInSeconds=self.assignment_duration_in_seconds,
            Question=self.question,
            QualificationRequirements=self.worker_requirements,
        )

        # The response included several fields that will be helpful later
        hit_type_id = response["HIT"]["HITTypeId"]
        hit_id = response["HIT"]["HITId"]
        print(f"A new HIT has been created.\nhit_id: {hit_id}\naddr: {self.get_hit_address(hit_type_id)}")

    def get_assignments_for_hit(self, HIT_ID):
        return self._client.list_assignments_for_hit(HITId=HIT_ID)

    def get_hit_address(self, hit_type_id):
        # You can work the HIT here:
        return f"https://workersandbox.mturk.com/mturk/preview?groupId={hit_type_id}"


if __name__ == "__main__":
    client = MTurkClient()
    client.create_hit()
    # print(client.get_assignments_for_hit("3UL5XDRDNC614XIQKH7AX2FWVJF58D"))
