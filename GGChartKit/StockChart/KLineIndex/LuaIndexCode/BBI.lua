-- BBI 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param {3, 6, 9, 12}

function BBIIndex(aryList, getMethod, param)

	table.sort(param)

	arrayBBI = {}
	arrayBlock = {}

	for i = 1, #param, 1 do

		arrayBlock[i] = MA(getMethod, param[i], aryList)
	end

	for i = 1, #aryList, 1 do

		if (i < param[#param]) then

			arrayBBI[i] = {bbi = "1.175494351e-38F"}
		else

			local sum = 0

			for j = 1, #arrayBlock, 1 do

				funcMa = arrayBlock[j]

				sum = sum + arrayBlock[j](i)
			end

			arrayBBI[i] = {bbi = sum / #param}
		end
	end

	return arrayBBI
end
