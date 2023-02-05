# README

## 실행 방법

1. 아래 코드를 실행하여 필요한 라이브러리 설치
    ```
    pip3 install -r requirements.txt 
    ```

2. `query_generator_v2.py` 파일을 실행하여 query 생성  
    예시1: Spider 데이터셋의 Car_1 데이터베이스를 사용할 경우
    ```
    python3 query_generator_v2.py \
    --num_queries 100 \
    --output car_1.sql \
    --schema_name car_1 \
    --db spider \
    --query_type spj-non-nested
    ```

    예시2: IMDB 데이터베이스를 사용할 경우
    ```
    python3 query_generator_v2.py \
    --num_queries 100 \
    --output imdb.sql \
    --schema_name imdb-full \
    --db imdb \
    --query_type spj-nested
    ```

    옵션을 수정하여 생성될 쿼리 결과 조정
    - num_queries: 생성될 쿼리의 개수 결정
    - output: 결과 파일의 이름 결정
    - schema_name: 데이터베이스 상에서 사용할 schema를 결정
    - db: 사용할 데이터베이스 결정
    - query_type: 생성할 쿼리의 타입 결정 (spj-non-nested, spj-nested, spj-mix, non-nested, nested, mix)

3. 생성된 쿼리 파일을 확인
4. Spider csv data: https://drive.google.com/file/d/1YRSnCph07IYQiegRcl8tptLNw7dTiKRX/view?usp=sharing
