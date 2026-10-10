import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:web/web.dart' as web;

void initDatabaseFactory() {
  // sqflite_common_ffi_web resolves `sqlite3.wasm` relative to the *current*
  // document URL by default. On a deep route (e.g. /entry/<word>) that becomes
  // /entry/sqlite3.wasm → 404 → GitHub Pages serves 404.html (text/html),
  // which the browser rejects with:
  //   "WebAssembly: Response has unsupported MIME type 'text/html' expected
  //    'application/wasm'".
  // Resolve the wasm URL against document.baseURI (which the browser computes
  // from <base href>) so it always points at the deployment root — works for
  // both custom-domain root and GitHub Pages subpath deployments, on any route.
  final wasmUri = Uri.parse(web.document.baseURI).resolve('sqlite3.wasm');
  databaseFactory = createDatabaseFactoryFfiWeb(
    noWebWorker: true,
    options: SqfliteFfiWebOptions(sqlite3WasmUri: wasmUri),
  );
}
