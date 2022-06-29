const blst = require("blst");

blst['onRuntimeInitialized'] = function() {
  var a = blst.P1_Affine.generator().compress();
  var p = new blst.P1_Affine(a);
}
