import argparse
import logging
import os

import boto3
import hkkang_utils.misc as misc_utils

# Load environment variables
misc_utils.load_dotenv(stack_depth=1)

# AWS keys
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRETE_ACCESS_KEY_ID = os.getenv("AWS_SECRETE_ACCESS_KEY_ID")

REGION = "us-east-1"
DEFAULT_ENDPOINT_URL = "https://mturk-requester.us-east-1.amazonaws.com"
SANDBOX_ENDPOINT_URL = "https://mturk-requester-sandbox.us-east-1.amazonaws.com"

logger = logging.getLogger("HIT_Generator")

print(AWS_ACCESS_KEY_ID, AWS_SECRETE_ACCESS_KEY_ID)


class MTurkClient:
    def __init__(
        self,
        use_sandbox: bool,
        endpoint_url: str,
        region_name: str,
        aws_access_key_id: str = AWS_ACCESS_KEY_ID,
        aws_secret_access_key: str = AWS_SECRETE_ACCESS_KEY_ID,
    ):
        self._client: boto3.client = None

        self.use_sandbox = use_sandbox
        # For building client
        self.region_name: str = region_name
        self.aws_access_key_id: str = aws_access_key_id
        self.aws_secret_access_key: str = aws_secret_access_key
        self.endpoint_url: str = endpoint_url
        # For creating HIT
        self.question_schema_path: str = os.path.join(os.path.dirname(__file__), "AMT_ExternalQuestion.xml")
        self.reward = "2"  # dollar
        self.max_assignments: int = 1
        self.lifetime_in_seconds: int = 60 * 60 * 24 * 7
        self.assignment_duration_in_seconds: int = 60 * 60 * 24 * 7
        self.__post_init__()

    def __post_init__(self):
        # Get question schema
        self.question = open(self.question_schema_path, "r", encoding="utf-8").read()
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
        if self.use_sandbox:
            return f"https://workersandbox.mturk.com/mturk/preview?groupId={hit_type_id}"
        return f"https://worker.mturk.com/mturk/preview?groupId={hit_type_id}"

    def get_hit_status(self, hit_id):
        print(self._client.get_hit(HITId=hit_id)["HIT"])

    def delete_hit(self, hit_id):
        self._client.delete_hit(HITId=hit_id)


def main(use_sandbox: bool):
    client = MTurkClient(
        use_sandbox=use_sandbox,
        region_name=REGION,
        endpoint_url=SANDBOX_ENDPOINT_URL if use_sandbox else DEFAULT_ENDPOINT_URL,
    )
    client.create_hit()

    # client.get_hit_status("3VQTAXTYN381RA6COU5B2CME82SBUU")
    # client.list_reviewable_hits()
    # client.delete_hit("3VQTAXTYN381RA6COU5B2CME82SBUU")
    # print(client.get_assignments_for_hit("3VQTAXTYN381RA6COU5B2CME82SBUU"))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--use_sandbox", action="store_true", help="Whether to use sandbox (useful for testing)")
    return parser.parse_args()


if __name__ == "__main__":
    logging.basicConfig(
        format="[%(asctime)s %(levelname)s %(name)s] %(message)s",
        datefmt="%m/%d %H:%M:%S",
        level=logging.INFO,
    )
    args = parse_args()

    main(use_sandbox=args.use_sandbox)
    logger.info("Done!")
