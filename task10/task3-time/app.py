import datetime
import time


def main() -> None:
    while True:
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"current time: {now}", flush=True)
        time.sleep(10)


if __name__ == "__main__":
    main()
