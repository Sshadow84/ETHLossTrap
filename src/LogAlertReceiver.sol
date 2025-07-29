// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogAlertReceiver {
    event AnomalyDetected(address indexed origin, string reason);

    /// @notice Called by Drosera when the trap triggers
    /// @param data Encoded (diff, percent)
    function logAnomaly(bytes calldata data) external {
        if (data.length == 0) {
            emit AnomalyDetected(msg.sender, "No anomaly data provided");
            return;
        }

        try this.decodeAndEmit(data) {
        } catch {
            emit AnomalyDetected(msg.sender, "Invalid anomaly payload");
        }
    }

    /// @dev Decodes diff and percent from trap and emits readable event
    function decodeAndEmit(bytes calldata data) external {
        (uint256 diff, uint256 percent) = abi.decode(data, (uint256, uint256));

        emit AnomalyDetected(
            msg.sender,
            string(
                abi.encodePacked(
                    "ETH loss: ",
                    _uint2str(diff),
                    " wei (",
                    _uint2str(percent),
                    "%)"
                )
            )
        );
    }

    /// @dev Converts uint256 to string
    function _uint2str(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 j = v;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = v;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
