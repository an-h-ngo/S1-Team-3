package com.yoursjsu.model;
import java.math.BigDecimal;

public class Charge {
    private int chargeId;
    private String termName;
    private BigDecimal amount;
    private String description;
    private String postedAt;
    private String status; // 'paid', 'pending', or 'overdue'

    public int getChargeId() { return chargeId; }
    public void setChargeId(int chargeId) { this.chargeId = chargeId; }

    public String getTermName() { return termName; }
    public void setTermName(String termName) { this.termName = termName; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPostedAt() { return postedAt; }
    public void setPostedAt(String postedAt) { this.postedAt = postedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
