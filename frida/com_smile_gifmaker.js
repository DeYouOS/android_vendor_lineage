var parametersMap = {
	region_ticket: "",
	did: "",
	oDid: "",
	rdid: "",
	egid: "",
	__NSWJ: "",
}
var isPrint = false
var hook = function () {
	Java.perform(function () {
		var ClassMap = Java.use("java.util.Map")
		var Psb_a = Java.use("psb.a")
		var iClass = Java.use("a25.i")
		var WeaponHI = Java.use("com.kuaishou.weapon.i.WeaponHI")
		iClass.t.implementation = function () {
			var result = this.t()
			if (parametersMap.region_ticket != result) {
				parametersMap.region_ticket = result
				isPrint = true
			}
			return result
		}
		var myWeaponHI = WeaponHI.$new()
		Psb_a.h.implementation = function (var0, var1, var2, var3, var4, var5, var6) {
			if ("GET" == var0.method()) {
				return this.h(var0, var1, var2, var3, var4, var5, var6)
			}
			this.h(var0, var1, var2, var3, var4, var5, var6)
			var tmp2 = Java.cast(var2, Java.use("java.util.HashMap"))
			var did = tmp2.get("did")
			if (parametersMap.did != did) {
				parametersMap.did = "" + did
				isPrint = true
			}
			var oDid = tmp2.get("oDid")
			if (parametersMap.oDid != oDid) {
				parametersMap.oDid = "" + oDid
				isPrint = true
			}
			var rdid = tmp2.get("rdid")
			if (parametersMap.rdid != rdid) {
				parametersMap.rdid = "" + rdid
				isPrint = true
			}
			var egid = tmp2.get("egid")
			if (parametersMap.egid != egid) {
				parametersMap.egid = "" + egid
				isPrint = true
			}
			var __NSWJ = myWeaponHI.getT()
			if (parametersMap.__NSWJ != __NSWJ) {
				parametersMap.__NSWJ = __NSWJ
				isPrint = true
			}
			if (isPrint && parametersMap.region_ticket && parametersMap.did && parametersMap.oDid && parametersMap.rdid && parametersMap.egid && parametersMap.__NSWJ) {
				isPrint = false
				console.log("parametersMap: ", JSON.stringify(parametersMap))
			}
		}
	})
}
rpc.exports = {
	init(stage, parameters) {
		if (parameters.process_name == parameters.package_name) {
			console.log('[init]', stage, JSON.stringify(parameters));
			hook()
		}
	},
	dispose() {
		console.log('[dispose]');
	}
};
