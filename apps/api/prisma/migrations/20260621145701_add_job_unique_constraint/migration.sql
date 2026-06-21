-- CreateIndex
CREATE UNIQUE INDEX "Job_type_payloadJson_status_key" ON "Job"("type", "payloadJson", "status");
