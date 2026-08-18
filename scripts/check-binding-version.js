#!/usr/bin/env node
/**
 * Fail the build if the packaged N-API binding was compiled against a different
 * Setapp library than this package version.
 *
 * `postbuild` copies `nodejs/lib/binding/node_setapp_binding.node` into
 * `nodejs/dist/lib/binding/`, and `nodejs/dist` is what `main` loads. That
 * source directory is gitignored, so on a machine where node-gyp has not run
 * for the current version it holds a binding left over from an earlier one -
 * and the copy succeeds silently.
 *
 * The binding statically links the Swift library, so the version it was built
 * against is the version consumers actually run, whatever package.json says.
 * Nothing downstream can detect or correct that.
 *
 * Every Mach-O the framework produces carries an embedded `__scv__<version>`
 * stamp. This compares that stamp with the package version.
 */
const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const pkg = require(path.join(root, "package.json"));
const binding = path.join(
  root, "nodejs", "dist", "lib", "binding", "node_setapp_binding.node",
);

if (!fs.existsSync(binding)) {
  console.error(`[check-binding-version] no binding at ${path.relative(root, binding)}`);
  console.error("  postbuild should have copied it from nodejs/lib/binding.");
  process.exit(1);
}

// latin1 so bytes survive decoding; the stamp is plain ASCII inside a binary.
const stamp = fs.readFileSync(binding, "latin1").match(/__scv__(\d+\.\d+\.\d+)/);

if (!stamp) {
  console.error(`[check-binding-version] no __scv__ version stamp found in the binding.`);
  process.exit(1);
}

if (stamp[1] !== pkg.version) {
  console.error(
    `[check-binding-version] the binding is built against Setapp ${stamp[1]}, ` +
    `but this package is ${pkg.version}.\n` +
    `\n` +
    `  ${path.relative(root, binding)}\n` +
    `\n` +
    `Publishing this would ship a library ${stamp[1]} runtime as ${pkg.version}: the\n` +
    `binding statically links the Swift library, so its version is what consumers run,\n` +
    `and any API added since ${stamp[1]} would be missing with no way to detect it.\n` +
    `\n` +
    `Rebuild the native binding for this version, then run the build again:\n` +
    `  npx node-gyp rebuild && npm run build\n`,
  );
  process.exit(1);
}

console.log(`[check-binding-version] binding matches package (Setapp ${pkg.version})`);
