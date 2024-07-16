# 3DPass-Mainnet-db

1. Download all `db.7z.00*` from the [latest release](https://github.com/Snezhnaya-Fatui/p3d-mainnet-db/releases) or use the batch download script:

   ```bash
   wget https://github.com/Snezhnaya-Fatui/p3d-mainnet-db/raw/main/download.sh && sudo chmod 777 download.sh && ./download.sh
   ```

   The downloaded files will be stored in the `./downloads` directory.

2. Install [7-Zip](https://github.com/Snezhnaya-Fatui/7-Zip) and unzip the files using `7z x db.7z.001`.

3. Delete the old `db` folder (usually under the path `/3dp-chain/chains/3dpass/`), and then move the new `db` folder into it.

---
