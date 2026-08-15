{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  testers,
}:

let
  version = "0.1.195";

  platform =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
      {
        url = "https://updates.rescile.com/v${version}/rescile-ce-linux-amd64";
        sha256 = "6e4c0b224084a969cb878dc687f312363b88d96114391d39716be9a5345216ff";
      }
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      {
        url = "https://updates.rescile.com/v${version}/rescile-ce-darwin-arm64";
        sha256 = "c03cc37457623affcce7e3f53d52ae8abdba85ffa786086a954e2f41203e78f3";
      }
    else
      throw "Unsupported platform: ${stdenv.hostPlatform.system}";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "rescile-ce";
  inherit version;

  src = fetchurl {
    inherit (platform) url sha256;
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ patchelf ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/rescile-ce
    chmod +x $out/bin/rescile-ce

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}" \
      $out/bin/rescile-ce
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "rescile-ce --version";
    };
  };

  meta = {
    description = "Rescile Communnity Edition";
    homepage = "https://rescile.com";
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = [ "torstenboettjer" ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "rescile-ce";
  };
})
