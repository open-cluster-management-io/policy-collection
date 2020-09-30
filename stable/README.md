# Policies -- Stable
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). NIST SP 800-53 Rev 4 also includes mapping to the ISO/IEC 27001 controls. For more information, read _Appendix H_ in [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Security control catalog
View a list of policies that are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management) and organized by the security control catalog.

<table>
  <tr>
    <th>Security Control</th>
    <th>Policies</th>
    <th>Prerequisites</th>
  </tr>
  <tr>
    <td rowspan="3">Access Control</td>
    <td><a href="./AC-Access-Control/policy-limitclusteradmin.yaml">policy-limitclusteradmin</a></td>
    <td></td>
  </tr>
  <tr>
    <td><a href="./AC-Access-Control/policy-role.yaml">policy-role</a></td>
    <td></td>
  </tr>
    <tr>
    <td><a href="./AC-Access-Control/policy-rolebinding.yaml">policy-rolebinding</a></td>
    <td></td>
  </tr>
  <tr>
    <td>Awareness and Training</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Audit and Accountability</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Security Assessment and Authorization</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td rowspan="4">Configuration Management</td>
    <td><a href="./CM-Configuration-Management/policy-limitmemory.yaml">policy-limitmemory</a></td>
    <td></td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-etcdencryption.yaml">policy-etcdencryption</a></td> 
    <td>Use an encryption policy to encrypt sensitive resources such as Secrets, ConfigMaps, Routes and  OAuth access tokens in your cluster. <br>See the <a href="https://access.redhat.com/documentation/en-us/openshift_container_platform/4.5/html/security/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd"> OpenShift Documentation </a> to learn how to enable ETCD post install.</td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-namespace.yaml">policy-namespace</a></td>
    <td></td>
  </tr>
    <tr>
    <td><a href="./CM-Configuration-Management/policy-pod.yaml">policy-pod</a></td>
    <td></td>
  </tr>
  <tr>
    <td>Contingency Planning</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Identification and Authentication</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Incident Response</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Maintenance</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Physical and Environmental Protection</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Planning</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Personnel Security</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>Risk Assessment</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>System and Services Acquisition</td>
    <td>N/A</td>
    <td></td>
  </tr>
  <tr>
    <td>System and Communications Protection</td>
    <td><a href="./SC-System-and-Communications-Protection/policy-certificate.yaml">policy-certificate</a></td>
    <td></td>
  </tr>
  <tr>
    <td rowspan="3">System and Information Integrity</td>
    <td><a href="./SI-System-and-Information-Integrity/policy-imagemanifestvuln.yaml">policy-imagemanifestvuln</a></td><td></td>
  </tr>
  <tr>
    <td><a href="./SI-System-and-Information-Integrity/policy-psp.yaml">policy-psp</a></td>
    <td></td>
  </tr>
    <tr>
    <td><a href="./SI-System-and-Information-Integrity/policy-scc.yaml">policy-scc</a></td>
    <td></td>
  </tr>
</table>
