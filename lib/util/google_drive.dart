import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:uuid/uuid.dart';

Future<String?> _getFolderId(ga.DriveApi driveApi, String folderName) async {
  const mimeType = "application/vnd.google-apps.folder";

  try {
    final found = await driveApi.files.list(
      q: "mimeType = '$mimeType' and name = '$folderName'",
      $fields: "files(id, name)",
    );
    final files = found.files;
    if (files == null) {
      devtools.log("Sign-in first Error");
      return null;
    }

    // The folder already exists
    if (files.isNotEmpty) {
      devtools.log("Folder found");
      return files.first.id;
    }

    // Create a folder
    ga.File folder = ga.File();
    folder.name = folderName;
    folder.mimeType = mimeType;
    final folderCreation = await driveApi.files.create(folder);
    devtools.log("Folder ID: ${folderCreation.id}");

    return folderCreation.id;
  } catch (e) {
    devtools.log(e.toString());
    return null;
  }
}

Future<String> uploadFileToGoogleDrive(File file) async {
  ServiceAccountCredentials accountCredentials =
      ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "ap-assassin-test",
    "private_key_id": "d7dcec2bfa975e7dcb712c7a49d2f972f8c99afb",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCfTkkxg4Wc9P02\nm9/2XpZka0BMim+b5xbVyrQRyOG9ku/vBy6fOneoE3YO9wOQ8cGCWEmu6FT4fNqm\nNc6fwmJ4BLt5/Kb9qK/DQbrioV8GXg0mL/KPUG5/kWKti/usGEBa1YN7P/mICKcf\nYbwgl/h+jAzjzuMtWYyeLLEKiY9Z2UowR0atKOgtFdms0vGQajU1EFQ+xTm8pf0l\nIUwqs1mDIpxOVtjnci6iVRvgzxxzJM8TeK5iapUUD75XKEBD/QeAwpRKi6sGgF35\naNl9IrpaepSdyxQE/2KU474kqQd79wpgSfzMRDgJOUVdvkJGo7Hf4/uSs++m8oM5\nCcADGH5XAgMBAAECggEABVCc04iSTB7GVeyUZ8lXFimX3xXdTGPE2MQnBtLfaS4+\nUAi6zvgp5tMjZLNsDIlsTdd5OdspfpLXzqTL7HuVQnDR+mtp/NuEZazLOeVtYK6B\nnM0LuClUTnBAzQ53CpJSj1VBSjrjrdywCrV9i87WLQ6qHW2ZGbm7ncla7MGTJUmz\nlh/WrHXdzTtimhFwO+Fh1ILf1hSLewHrJ8otvrii9iO/yyFckQGHJ06Ds/p7L7ar\n3pJT1Y0aI+kT8nTc/D26tPnUBvn/ykDOYVOIc1lc2x02FHl4ziOBDu6QxqOAinzq\nnpPvDb/kyH+5ufR4JJJsNa+WdEBzfSurWm1vLZEkNQKBgQDW5hzjRoRlusRxrMtr\n+DdFpuiMOa3W3zK3KguMX5DQJDNDdmunXe4sGxCPTd68chS81ldtgvaZbF7TkcKA\ntyWVl56/YEZfSSBNZbp4qj20EDDgwI6txNwHF18cvXXyfinDwmURH48GebWLxLd5\nGml5GOgYsZqm1r+XcqNxHhafmwKBgQC9xjkMFMwrcWsCFetFC4Lg0MBMce7eYWnj\nQZZ6FTQE3DAo6ZR4nxsz5dm156BUgd6nI4Y/bG1nbXnJv/mwMz+nc6TbFbR+HTIY\nK/TjRF55JoLu2hGSupHcHMs05xREtBqJlqD/YaoRJDUx7+Dl+Fo19GCAfZcPmrt+\nlajqYSKt9QKBgBa4c5tv7DWZPoXKQCOlNarOj82rl36dUI5fCqOHwxbOjQD39z/V\nxYWyQtjz4bXI1fp1Kv8wFoR4GbqCsa7MLlQXmLghJK+UWq70L3fsf+OWxqQsl6k1\npBG33d17Boph3maNGgRqcsO7gH9LiB5stXQRNxDNTk2PbOhFPZSLGtc7AoGAKL1F\n/97zGZxmgXMdJ5xaA1MtBPwscFbvOVcaK6kjmqt+Nzo1olNdrp14SEGqPJoIp07M\nAg+PyPVKgNISkw3da2A7EsEtFynDWEcPcj56HX3z+7yaqyocJ+mSgg/dXQZg8AqD\nE2/u53Ejbk31tMjE7PJCSTMs26+28mzEb1Rc8oUCgYBMqRiYEsSbX7/+8n1Aubi+\nnwe1hNjN2+2Q2z/am3ZU6KV2HbmCJxbRmFh7ozExFy6VV15eNJ1K62y8pWj6Dlu5\nlnRHJ7lzDEo1wZRVl900n5AGN5GkTqYS/INr8q/2EuM2XO0W1aKgBYcZtb8QhTQS\nsnCCqyGO8iNxuT/zVvKxHg==\n-----END PRIVATE KEY-----\n",
    "client_email":
        "google-drive-uploader@ap-assassin-test.iam.gserviceaccount.com",
    "client_id": "105297153016066108827",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/google-drive-uploader%40ap-assassin-test.iam.gserviceaccount.com"
  });

  ServiceAccountCredentials accountCredentials2 =
      ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "ap-assassin-test",
    "private_key_id": "ef06a07f07518ed4666ed6e399178d37d181b86c",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCoRYYfj9mcCteP\n69vxFNyU8nLq6IkWVasNaFbry6K3BlTHgUlFe0memayOoMOiqICBK/IucBTw5Oc1\nPFE3HXSJYEeMPA+8qRPlqEYbO0d+xbQAv7Al0VLrOz8WH7o57sThUvQGqz+i1T3f\nEdhFv6QSyZJs6Nz7MWA88OPfk82/J38DJWDXUeIxsNKVOytIcvuAJLYL7OUUhBPH\n0SyuxeGY2g0qtqRlHfGlwGtCOxscy6AFJEI5kD/5+b4tuFB0AC0FRFQXHg12NzRd\nMUb63zAI1kEv04J6sofXppXOtBJVX+SRx+Cq14xLqvr3OVCNmekcPIv/NQWluu0h\nTxrHnXSbAgMBAAECggEABVgH4xva0uMW+SZlY+DAKANbrFpsKmKzhvVVd59E8JtX\nS1hmeAMh49Ma+jdyzMkvtdgsJukaUSXfRLX3huL9A3UAAviHC2oODGxbN+VRVPCd\niKtpL/WzIkoo9OB7o68RqCSEso/OjNdtrN91NLL+oaPTJQu4tW6jR+wrqZZ0fPv6\nJAB1bFWa3tWP89W2kGwTSAzc8+Kxyefo6IIDkKHgPs/r7s1CePdaG5v2fyF7kMuF\nDPeMDf42Z85MnwtJM/0OcMWeMa9QU7CnJn43W9rSQWkn8XLy6HfCJJvb796tUgty\nMBBW2KcMGIit4ljEKKZt75wAwqNVWx7002ZXXZt6iQKBgQDoHFmoFjB9QYjSIqNu\nO/iBLWHqLTuMOc4GgRHkp702vL1iILHWE2FFYPaLiVF3uakkIgnQs0Oas8ZvkPJH\np1iex4hRBQ5uGVrj3zDeJQa8y+PMvTwNYKJ2eZMT6c/2zc4s9OPP4wY7mL94a0uj\nygp2x6xyTLZCK+hjXY1MTKpCRQKBgQC5lyP3bCaj+8nBr5bvDu4ZmBAcYOf/4tBG\nHyaF2kKQK/1Dk6ISoJWnq3NSLAJGl8TCOAp8Xr+DulT97y2SGt5leorZ2Hgi/aSP\n2tb597gI3dEYfdVIb7ZgteqIn0jtYsAYWhJcLlxa0aUnnFAeaxFi7tBC6VwPfLxs\nD2HOjo+5XwKBgQC7QWPzfzNPWfePz/IZlLg/PuWnjyZjUp8sECTnW4wDBPGkoMvX\n8XqgBkHhAL+A33/dbriMbpMz06VbjIxp0lBkiIUpF/M0T7BL9lvuW+C7n6IAIwq3\noCZxflNx1Ue5zP9wtYC0zmrQ2cJe2/ECCpW2jhBJhinj6Jhq0aaUz6TsIQKBgQCN\n9dBrJ+z+rlCLuRZI0jDKnwhjzLRphUMvABDlfihAQ4W8tSbZ/L+8u2bAyi0Ldnfo\n4BkVPRxdVKBChTtkcO0AzpV7QRvUGBRSfWDHX/cDwTh59Xa5q8njfANkcgLEoi6x\n8ePtYwD97zLXc7fNLLTl6iqfpATpS86NEc8MwvupHQKBgAUMOI3+vzhST2hlmLyR\nOBeknMaZByOLdT6qdxqcMClHk22lvg0s32dLMNJ8Epsi3LO4XvNv91QchT0cSzVj\n4eAYbjl9j1kr/2jpgoja2cBPzua5uqYjLz++FxwmGecPxjTauHEslypXkoCQvLXY\nrpRAyV6Bu0RZ9dS++rnBs5Ik\n-----END PRIVATE KEY-----\n",
    "client_email":
        "google-drive-uploader-2@ap-assassin-test.iam.gserviceaccount.com",
    "client_id": "115911885999716423108",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/google-drive-uploader-2%40ap-assassin-test.iam.gserviceaccount.com"
  });

  List<String> scopes = [ga.DriveApi.driveScope];

  AuthClient client = await clientViaServiceAccount(accountCredentials, scopes);
  var drive = ga.DriveApi(client);

  ga.About about = await drive.about.get($fields: '*');
  // print(about.storageQuota?.usage ?? 'no usage');
  // print(about.storageQuota?.limit ?? 'no limit');

  // AuthClient client2 =
  //     await clientViaServiceAccount(accountCredentials2, scopes);
  // var drive2 = ga.DriveApi(client2);

  // ga.About about2 = await drive2.about.get($fields: '*');
  // print('------');
  // print(about2.storageQuota?.usage ?? 'no usage');
  // print(about2.storageQuota?.limit ?? 'no limit');

  String? folderId = await _getFolderId(drive, "AP Assassin Files");
  if (folderId == null) {
    devtools.log("Sign-in first Error");
    return '';
  } else {
    ga.File fileToUpload = ga.File();
    fileToUpload.parents = [folderId];
    fileToUpload.name = const Uuid().v4();
    var response = await drive.files.create(
      fileToUpload,
      uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
    );
    final fileId = response.id!;
    await drive.permissions
        .create(ga.Permission(role: 'reader', type: 'anyone'), fileId);
    devtools.log("Upload Complete");

    return 'https://drive.google.com/uc?export=view&id=${response.id}&confirm=t';
  }
}
