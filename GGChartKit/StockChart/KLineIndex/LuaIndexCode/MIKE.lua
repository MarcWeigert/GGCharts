-- MIKE指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param 12

function MIKEIndex(aryList, getMethodHigh, getMethodLow, getMethodClose, param)

	MIKEArray = {}
	funcHHV = HHV(getMethodHigh, param)
	funcLLV = LLV(getMethodLow, param)

	for i = 1, #aryList, 1 do
	
		ntyp = (aryList[i][getMethodHigh] + aryList[i][getMethodLow] + aryList[i][getMethodClose]) / 3
		nllv = funcLLV(i, aryList)
		nhhv = funcHHV(i, aryList)
	
		mike = {}
		mike["wr"] = ntyp + (ntyp - nllv)
		mike["mr"] = ntyp + (nhhv - nllv)
		mike["sr"] = 2 * nhhv - nllv
		mike["ws"] = ntyp - (nhhv - ntyp)
		mike["ms"] = ntyp - (nhhv - nllv)
		mike["ss"] = 2 * nllv - nhhv
		
		MIKEArray[i] = mike
	end

	return MIKEArray
end
