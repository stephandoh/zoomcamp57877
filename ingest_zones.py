import click
import requests
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path


def download_file(url: str, output_path: Path):
    if output_path.exists():
        print(f"📁 {output_path.name} already exists, skipping download")
        return

    print(f"⬇️ Downloading {url}")
    response = requests.get(url)
    response.raise_for_status()

    output_path.write_bytes(response.content)
    print("✅ Download complete")


@click.command()
@click.option('--pg-user', default='root')
@click.option('--pg-password', default='root')
@click.option('--pg-host', default='localhost')
@click.option('--pg-port', default=5433)
@click.option('--pg-db', default='ny_taxi')
@click.option(
    '--url',
    default='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv'
)
@click.option(
    '--table',
    default='zones'
)
def main(pg_user, pg_password, pg_host, pg_port, pg_db, url, table):
    """
    Download and ingest taxi zone lookup data into Postgres
    """

    file_path = Path(url.split('/')[-1])

    download_file(url, file_path)

    print(f"📥 Reading CSV file: {file_path}")
    df = pd.read_csv(file_path)

    engine = create_engine(
        f'postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_db}'
    )

    print(f"🗄 Writing data to table: {table}")
    df.to_sql(
        name=table,
        con=engine,
        if_exists='replace',
        index=False
    )

    print("✅ Taxi zone ingestion finished")


if __name__ == '__main__':
    main()
