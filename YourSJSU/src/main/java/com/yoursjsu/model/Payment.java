package com.yoursjsu.model;
import java.math.BigDecimal;

public class Payment {
    private int paymentId;
    private String termName;
    private BigDecimal amount;
    private String paidAt;

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public String getTermName() { return termName; }
    public void setTermName(String termName) { this.termName = termName; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaidAt() { return paidAt; }
    public void setPaidAt(String paidAt) { this.paidAt = paidAt; }
}
