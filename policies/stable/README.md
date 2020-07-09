# Policies -- Stable
Policies in this folder are organized by [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework). For more information, please read [Framework V1.1 PDF](https://nvlpubs.nist.gov/nistpubs/CSWP/NIST.CSWP.04162018.pdf).

## Policies Organized by Categories

* Identify
  * ID.AM
  * ID.BE
  * ID.GV
  * ID.RA
  * ID.RM
  * ID.SC
* Protect
  * PR.AC
    * [policy-limitclusteradmin](./PR.AC/policy-limitclusteradmin.yaml)
    * [policy-role](./PR.AC/policy-role.yaml)
    * [policy-rolebinding](./PR.AC/policy-rolebinding.yaml)
  * PR.AT
  * PR.DS
  * PR.IP
    * [policy-limitmemory](./PR.IP/policy-limitmemory.yaml)
    * [policy-namespace](./PR.IP/policy-namespace.yaml)
  * PR.MA
  * PR.PT
    * [policy-pod](./PR.PT/policy-pod.yaml)
    * [policy-psp](./PR.PT/policy-psp.yaml)
    * [policy-scc](./PR.PT/policy-scc.yaml)
* Detect
  * DE.AE
  * DE.CM
    * [policy-imagemanifestvuln](./DE.CM/policy-imagemanifestvuln.yaml)
  * DE.DP
* Respond
  * RS.RP
  * RS.CO
  * RS.AN
  * RS.IM
* Recover
  * RC.RP
  * RC.IM
  * RC.CO

