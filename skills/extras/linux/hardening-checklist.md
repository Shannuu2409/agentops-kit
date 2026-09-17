# Linux Host Hardening Checklist

- [ ] Minimal package set; unused services disabled
- [ ] Automatic security updates or immutable image rebuilds
- [ ] SSH: keys only, `PermitRootLogin no`, allowlist users/groups
- [ ] Prefer SSM/bastion over public SSH
- [ ] Firewall default deny (nftables/UFW/security groups)
- [ ] auditd or equivalent for privileged actions
- [ ] SELinux/AppArmor enforcing where supported
- [ ] Separate disks for logs/data; alert on space and inodes
- [ ] chrony/NTP configured
- [ ] Kernel/sysctl hardening tested before broad rollout
- [ ] Agents: logging, metrics, vulnerability scanner

---

**Author & maintainer:** Shanmukha Kumar Karra  
*Created and maintained as part of [AgentOps Kit](https://github.com/Shannuu2409/agentops-kit).*
