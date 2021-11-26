import pytest
from brownie import Lottery, accounts, config, network
from scripts.deploy_lottery import deploy_lottery
from scripts.utils import LOCAL_BLOCKCHAIN_ENVIRONMENTS
from web3 import Web3


def test_get_entrance_fee():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    lottery = deploy_lottery()
    # Act
    # 2000 USD = 1 ETH
    # So, 50 USD or Entr fee = 50/2000 = 0.025
    expected_entrance_fee = Web3.toWei(0.025, "ether")
    print(lottery)
    entrance_fee = lottery.getEntranceFee()
    # Assert
    assert expected_entrance_fee == entrance_fee
