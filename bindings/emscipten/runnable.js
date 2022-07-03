const blst = require("blst");

blst['onRuntimeInitialized'] = function() {
  var a = blst.P2_Affine.generator();
  var p = new blst.P2_Affine(a.compress());
  if (!p.is_equal(a)) throw "disaster";
  var x = p.to_jacobian();
  var y = new blst.P2.generator();
  if (!p.is_equal(y.to_affine())) throw "disaster";
  x.dbl();
  y.add(p);
  if (!x.is_equal(y)) throw "disaster";
  console.log("OK");
}
