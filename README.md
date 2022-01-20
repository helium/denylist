# Helium, Inc - Denylist

The Helium community requested Helium, Inc. to maintain a temporary Hotspot
Denylist [through an on-chain vote][vote] around block 1,180,295 (approximately
2022-01-14 04:57 UTC).

The Helium compiled firmware of Original Helium Hotspots (and RAK Hotspots) will
use this list in the following manner. Hotspots performing the Challenger role
for the Proof-of-Coverage system:

* will not generate challenges for Hotspots in the denylist.
* will drop witness receipts for Hotspots in the denylist.

We won’t be able to mark individual witness receipts as invalid due to presence
in denylist as it would break consensus rules. A more complex implementation
that includes this could be implemented in the coming weeks as a part of a
[HIP-40][HIP-40] implementation.

Other manufacturers will have the option of loading this denylist or other lists
if they choose to do so and using that feature, their Hotspots will also take
the same actions.

We may, or may not, choose to publish the methodology that is used to generate
these new lists as that would potentially allow suspicious Hotspot deployers to
identify the analysis approaches that we utilize. These lists will be published
as frequently as we determine is necessary. They will be signed by Helium, Inc.
as a part of a multisig with members consisting of community contributors and
other researchers who suppor the work to generate this list.

Since these lists are going to be public, other tools like Explorer and
Hotspotty may use them to visualize suspicious activity. In the coming weeks we
will update the Helium mobile app to include a warning during the transfer
Hotspot process if a Hotspot being transferred is on the suspected list.

We will publish these lists in two forms as releases in this repository:

* A plaintext file that includes every Hotspot’s public key in base68 format.
* A binary xor filter that can be loaded via configuration to activate the above
  feature.

[vote]: https://heliumvote.com/14iwaexUYUe5taFgb5hx2BZw74z3TSyonRLYyZU1RbddV4bJest
[HIP-40]: https://github.com/helium/HIP/blob/master/0040-validator-denylist.md