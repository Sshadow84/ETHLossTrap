// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract ETHLossTrap is ITrap {
    address public constant target = 0x6493...7498;
    uint256 public constant thresholdPercent = 1;
    uint256 public constant minDiffWei = 0.01 ether;

    function collect() external view override returns (bytes memory) {
        return abi.encode(target.balance);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, abi.encode("Not enough data"));

        uint256 latest = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        if (previous == 0) return (false, abi.encode("First run"));

        if (latest < previous) {
            uint256 diff = previous - latest;
            uint256 percent = (diff * 100) / previous;

            if (diff >= minDiffWei && percent >= thresholdPercent) {
                // Возвращаем четко закодированные значения (diff, percent)
                return (true, abi.encode(diff, percent));
            }
        }

        return (false, "");
    }

    function uint2str(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 j = v;
        uint256 len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = v;
        while (j != 0) { bstr[--k] = bytes1(uint8(48 + j % 10)); j /= 10; }
        return string(bstr);
    }
}
