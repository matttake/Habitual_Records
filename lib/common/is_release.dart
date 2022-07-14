// 本番かリリースかを判断する
// releaseモードならtrueを返す
bool isRelease() {
  bool isRelease;
  // release環境ならtrue
  const bool.fromEnvironment('dart.vm.product')
      ? isRelease = true
      : isRelease = false;
  return isRelease;
}
