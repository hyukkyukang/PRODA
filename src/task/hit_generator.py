import os
import attrs
import boto3
from hkkang_utils.misc import property_with_cache

IS_USE_SANDBOX = False

# kanghk2428@postech.ac.kr
KANGHK2428_AWS_ACCESS_KEY_ID = "AKIAYRRBYHW4EQTXXL75"
KANGHK2428_AWS_SECRETE_ACCESS_KEY_ID = "NLKYtfjXcdY5f5qwOusUjZCp8COjuDHLEZNdCay/"
# hkkang@dblab.postech.ac.kr
# HKKANG_AWS_ACCESS_KEY_ID = "AKIAWSB2ZMJ7TB2KYB6E"
# HKKANG_AWS_SECRETE_ACCESS_KEY_ID = "eQ1wUL9C9Un0Dx6GI7Whi8GDIYQUgEMjndaz8n2Q"

# Select which account to use
AWS_ACCESS_KEY_ID = KANGHK2428_AWS_ACCESS_KEY_ID
AWS_SECRETE_ACCESS_KEY_ID = KANGHK2428_AWS_SECRETE_ACCESS_KEY_ID

# AWS_ACCESS_KEY_ID = HKKANG_AWS_ACCESS_KEY_ID
# AWS_SECRETE_ACCESS_KEY_ID = HKKANG_AWS_SECRETE_ACCESS_KEY_ID

DEFAULT_ENDPOINT_URL = "https://mturk-requester.us-east-1.amazonaws.com"
SANDBOX_ENDPOINT_URL = "https://mturk-requester-sandbox.us-east-1.amazonaws.com"
ENDPOINT_URL = SANDBOX_ENDPOINT_URL if IS_USE_SANDBOX else DEFAULT_ENDPOINT_URL


@attrs.define
class MTurkClient:
    _client: boto3.client = attrs.field(init=False)
    # For building client
    region_name: str = attrs.field(default="us-east-1")
    aws_access_key_id: str = attrs.field(default=AWS_ACCESS_KEY_ID)
    aws_secret_access_key: str = attrs.field(default=AWS_SECRETE_ACCESS_KEY_ID)
    endpoint_url: str = attrs.field(default=ENDPOINT_URL)
    # For creating HIT
    _question = attrs.field(init=False)
    question_schema_path: str = attrs.field(default=os.path.join(os.path.dirname(__file__), "AMT_ExternalQuestion.xml"))
    reward = attrs.field(default="0.01")
    max_assignments: int = attrs.field(default=1)
    lifetime_in_seconds: int = attrs.field(default=60 * 60 * 1)
    assignment_duration_in_seconds: int = attrs.field(default=60 * 60 * 1)

    def __attrs_post_init__(self):
        self._client = boto3.client(
            service_name="mturk",
            endpoint_url=self.endpoint_url,
            region_name=self.region_name,
            aws_access_key_id=self.aws_access_key_id,
            aws_secret_access_key=self.aws_secret_access_key,
        )
        print(f'Available balance: {self._client.get_account_balance()["AvailableBalance"]}')

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

    def list_hits(self):
        response = self._client.list_hits()
        print(response)

    def list_reviewable_hits(self):
        response = self._client.list_reviewable_hits()
        print(response)

    def get_assignments_for_hit(self, HIT_ID):
        return self._client.list_assignments_for_hit(HITId=HIT_ID)

    def get_hit_address(self, hit_type_id):
        # You can work the HIT here:
        if IS_USE_SANDBOX:
            return f"https://workersandbox.mturk.com/mturk/preview?groupId={hit_type_id}"
        else:
            return f"https://worker.mturk.com/mturk/preview?groupId={hit_type_id}"

    def get_hit_status(self, hit_id):
        print(self._client.get_hit(HITId=hit_id)["HIT"])

    def delete_hit(self, hit_id):
        self._client.delete_hit(HITId=hit_id)


if __name__ == "__main__":
    client = MTurkClient()
    # client.create_hit()
    client.get_hit_status("3VQTAXTYN381RA6COU5B2CME82SBUU")
    # client.list_reviewable_hits()
    # client.delete_hit("3VQTAXTYN381RA6COU5B2CME82SBUU")
    # print(client.get_assignments_for_hit("3VQTAXTYN381RA6COU5B2CME82SBUU"))
