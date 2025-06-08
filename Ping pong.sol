// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContratoPingPong {
    address public parAddress;
    uint256 public constant AMOUNT_TO_SEND = 1e12; // 0.000001 MON

    event Received(address sender, uint256 amount);
    event Sent(address to, uint256 amount);

    function setParAddress(address _parAddress) external {
        parAddress = _parAddress;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);

        // Se temos par e saldo, envia pro par
        if (parAddress != address(0) && address(this).balance >= AMOUNT_TO_SEND) {
            // Envia MON para o par — gera nova transação que chamará o receive() lá
            (bool success, ) = parAddress.call{value: AMOUNT_TO_SEND}("");
            if (success) {
                emit Sent(parAddress, AMOUNT_TO_SEND);
            }
        }
    }

    function deposit() external payable {
        emit Received(msg.sender, msg.value);
    }

    function withdrawAll(address payable _to) external {
        _to.transfer(address(this).balance);
    }
}
