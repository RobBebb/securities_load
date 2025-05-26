import logging

import pandas as pd
import yfinance as yf

from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import (
    add_or_update_ohlcvs,
    get_data_vendor_id,
    get_tickers_using_exchange_code,
)

logger = logging.getLogger(__name__)


def load_ohlcv_from_yahoo(period: str = "5d") -> None:
    """

    Args:
        period (str): 1d, 5d, 1mo, 3mo, 6mo, 1y, 2y, 5y, 10y, ytd, max
    """

    logger.debug("Started")

    # disable chained assignments
    pd.options.mode.chained_assignment = None
    logger.debug("Chained assignments disabled")
    pd.options.mode.copy_on_write = True

    input_period = period

    # Open a connection
    conn = connect()
    engine = sqlalchemy_engine()

    YAHOO_CODE = "Yahoo"
    EXCHANGE_CODE = "XASX"

    data_vendor_id = get_data_vendor_id(engine, YAHOO_CODE)
    if data_vendor_id is None:
        logger.error(f"No data_vendor_id found for YAHOO_CODE: {YAHOO_CODE}!")
        return

    tickers = get_tickers_using_exchange_code(engine, EXCHANGE_CODE)

    if tickers is None:
        logger.error(f"No tickers found for EXCHANGE_CODE: {EXCHANGE_CODE}!")
        return

    for ticker_tuple in tickers:
        ticker_id = ticker_tuple[0]
        yahoo_ticker = ticker_tuple[1]
        if yahoo_ticker in [
            "CCE.AX",
            "NVQ.AX",
            "AJXN.AX",
            "AUQN.AX",
            "AVZ.AX",
            "AZS.AX",
            "BEE.AX",
            "BEX.AX",
            "C79.AX",
            "CHK.AX",
            "CANN.AX",
            "ERLN.AX",
            "FG1NA.AX",
            "FOR.AX",
            "H2GN.AX",
            "HYTN.AX",
            "LNK.AX",
            "LPDN.AX",
            "HLXE.AX",
            "MIL.AX",
            "MZZ.AX",
            "NBI.AX",
            "NPR.AX",
            "ORM.AX",
            "OSXN.AX",
            "PBP.AX",
            "LRVNA.AX",
            "MBKN.AX",
            "MRGN.AX",
            "SLR.AX",
            "TIE.AX",
            "OECN.AX",
            "UBINB.AX",
            "VHT.AX",
            "VRXND.AX",
            "VTXN.AX",
            "^AXNV",
            "^AXLD",
            "PRSN.AX",
            "MRM.AX",
            "PH2DD.AX",
            "NZO.AX",
            "BYE.AX",
            "DOR.AX",
            "SGC.AX",
            "ABC.AX",
            "BLD.AX",
            "CSR.AX",
            "AWC.AX",
            "MPG.AX",
            "BSE.AX",
            "KIN.AX",
            "MCT.AX",
            "MLM.AX",
            "NKL.AX",
            "PNX.AX",
            "SRX.AX",
            "TMR.AX",
            "VMS.AX",
            "ZER.AX",
            "RED.AX",
            "FFX.AX",
            "SIH.AX",
            "DCX.AX",
            "GGR.AX",
            "PNX.AX",
            "DCG.AX",
            "ECG.AX",
            "APM.AX",
            "QIP.AX",
            "YPB.AX",
            "GUD.AX",
            "MCL.AX",
            "KED.AX",
            "INL.AX",
            "MMM.AX",
            "1AG.AX",
            "JTL.AX",
            "ME1.AX",
            "VUK.AX",
            "ATB.AX",
            "DXA.AX",
            "IAN.AX",
            "VEL.AX",
            "PGL.AX",
            "MGF.AX",
            "PGI.AX",
            "ALU.AX",
            "AND.AX",
            "SCL.AX",
            "K2F.AX",
            "AFW.AX",
            "GNX.AX",
            "MXU.AX",
            "MEA.AX",
            "RDNNB.AX",
            "^AXSY",
            "CHRCA.AX",
            "GSR.AX",
            "PNV.AX",
            "PRG.AX",
            "AJQ.AX",
            "PAN.AX",
            "RXM.AX",
            "TBA.AX",
            "LLO.AX",
            "ELE.AX",
            "AJY.AX",
            "NGL.AX",
            "CFO.AX",
            "ROO.AX",
            "NAM.AX",
            "BKG.AX",
            "E33.AX",
            "HLF.AX",
            "CSF.AX",
            "AMT.AX",
            "AC8.AX",
            "QVE.AX",
            "TSK.AX",
            "LVT.AX",
            "RVS.AX",
            "DMC.AX",
            "RIL.AX",
            "MEGN.AX",
            "PSI.AX",
            "AYU.AX",
        ]:
            continue
        elif yahoo_ticker in [
            "^AXBK",
            "^AXBN",
            "^AXNI",
            "^AXRI",
            "^AXET",
            "^AXEW",
            "^AXJM",
            "^AXJS",
            "^AXFR",
            "^AXFE",
            "^AXFN",
            "^AXJT",
            "^AXNT",
            "^AXRE",
            "^AXIN",
            "^AXVI",
            "^AXSY",
            "^AXAG",
            "^AXAF",
            "^AXGD",
            "^AXTX",
            "^AXDI",
            "^AXEC",
            "^AXAE",
        ]:
            period = "5d"
        elif yahoo_ticker in [
            "AHI.AX",
            "AKP.AX",
            "ANL.AX",
            "AO1.AX",
            "ATU.AX",
            "AYI.AX",
            "BOD.AX",
            "CI1.AX",
            "CSE.AX",
            "DCL.AX",
            "DLM.AX",
            "DMM.AX",
            "DNK.AX",
            "EMUCA.AX",
            "EPN.AX",
            "EQE.AX",
            "ETR.AX",
            "G1A.AX",
            "GGX.AX",
            "GO2.AX",
            "GTH.AX",
            "HPP.AX",
            "ICN.AX",
            "IEQ.AX",
            "KDY.AX",
            "KLL.AX",
            "KNM.AX",
            "KTG.AX",
            "LAW.AX",
            "LHM.AX",
            "LKO.AX",
            "LLL.AX",
            "M8S.AX",
            "MBX.AX",
            "MDC.AX",
            "MRI.AX",
            "NCR.AX",
            "NET.AX",
            "NNG.AX",
            "NUH.AX",
            "NZS.AX",
            "OM1.AX",
            "OPN.AX",
            "OXT.AX",
            "OZZ.AX",
            "PET.AX",
            "PO3.AX",
            "POW.AX",
            "PRL.AX",
            "MMC.AX",
            "MNS.AX",
            "AR1.AX",
            "CLB.AX",
            "CIO.AX",
            "RAN.AX",
            "RXH.AX",
            "SCT.AX",
            "SRY.AX",
            "STA.AX",
            "TI1.AX",
            "TMZ.AX",
            "TTA.AX",
            "VIP.AX",
            "VMG.AX",
            "WFL.AX",
            "X64.AX",
            "XTC.AX",
        ]:
            period = "max"
        else:
            period = input_period

        yf_ticker = yf.Ticker(yahoo_ticker)
        logger.debug(f"Prcessing ticker: {yahoo_ticker}")

        df = yf_ticker.history(period=period, repair=False)

        if not df.empty:
            df = df.reset_index(drop=False)
            hist = df.dropna()
            hist["ticker_id"] = ticker_id
            hist["data_vendor_id"] = data_vendor_id
            local_date = hist.loc[:, "Date"].dt.tz_localize(None)
            hist_prices = hist[
                [
                    "Open",
                    "High",
                    "Low",
                    "Close",
                    "Volume",
                    "ticker_id",
                    "data_vendor_id",
                ]
            ]
            hist_prices = pd.concat([hist_prices, local_date], axis=1)
            hist_prices.columns = [
                "open",
                "high",
                "low",
                "close",
                "volume",
                "ticker_id",
                "data_vendor_id",
                "date",
            ]

            add_or_update_ohlcvs(conn, hist_prices)

    # Close the connection
    conn.close()
    logger.debug("Finished")
