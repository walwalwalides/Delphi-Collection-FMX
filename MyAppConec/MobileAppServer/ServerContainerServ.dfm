object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 48
    Top = 35
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Server = DSServer1
    Filters = <>
    Left = 104
    Top = 9
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 40
    Top = 91
  end
end
