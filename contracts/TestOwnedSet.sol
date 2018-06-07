// Copyright 2018 Parity Technologies Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// A testable version of the `OwnedSet` contract that exposes some internal
// state and allows setting the system address.

pragma solidity ^0.4.22;

import "./OwnedSet.sol";


contract TestOwnedSet is OwnedSet {
	// allow mocking system address
	address systemAddress;

	constructor(address _systemAddress, address[] _initial) OwnedSet(_initial)
		public
	{
		systemAddress = _systemAddress;
	}

	// expose `status` to use for assertions in tests
	function getStatus(address _validator)
		public
		view
		returns (bool isIn, uint index)
	{
		AddressStatus storage addressStatus = status[_validator];

		isIn = addressStatus.isIn;
		index = addressStatus.index;
	}

	// re-declare these methods to use the mocked system address
	modifier onlySystemAndNotFinalized() {
		require(msg.sender == systemAddress && !finalized);
		_;
	}

	function finalizeChange()
		external
		onlySystemAndNotFinalized
	{
		finalizeChangeInternal();
	}
}
